//
//  CarRepository.swift
//  Mobing
//
//  Created by Daffa Khoirul on 29/05/25.
//

import Foundation
import FirebaseDatabase


class FireBaseCarRepository {
    private let ref: DatabaseReference

    init() {
        self.ref = Database.database().reference().child("cars")
    }

    func fetchCars() async throws -> [CarModel] {
        return try await withCheckedThrowingContinuation { continuation in
            ref.observeSingleEvent(of: .value, with: { snapshot in
                print("Snapshot fetched: \(snapshot)")

                guard !(snapshot.value is NSNull) else {
                    print("❌ Tidak ada data mobil ditemukan.")
                    continuation.resume(returning: []) // Kembalikan array kosong jika tidak ada data
                    return
                }

                guard let rawValue = snapshot.value as? [[String: Any]] else {
                    print("❌ Snapshot.value bukan array of dictionaries: \(String(describing: snapshot.value))")
                    // Menggunakan NSError standar
                    continuation.resume(throwing: NSError(domain: "FireBaseCarRepository", code: 1001, userInfo: [NSLocalizedDescriptionKey: "Format data mobil dari server tidak valid."]))
                    return
                }

                let fetchedCars: [CarModel] = rawValue.compactMap { carDict in
                    guard let jsonData = try? JSONSerialization.data(withJSONObject: carDict),
                          let car = try? JSONDecoder().decode(CarModel.self, from: jsonData) else {
                        print("❌ Gagal decode item: \(carDict)")
                        return nil
                    }
                    return car
                }
                continuation.resume(returning: fetchedCars.sorted { $0.yearBuilt > $1.yearBuilt })
            }) { error in
                print("Firebase fetch error: \(error.localizedDescription)")
                continuation.resume(throwing: error) // Langsung teruskan error dari Firebase
            }
        }
    }

    /// Mengambil data mobil berdasarkan ID secara asinkron.
    func fetchCarById(for carID: Int) async throws -> CarModel? {
        let carRef = ref.child(String(carID))

        return try await withCheckedThrowingContinuation { continuation in
            carRef.observeSingleEvent(of: .value) { snapshot in
                guard !(snapshot.value is NSNull) else {
                    continuation.resume(returning: nil) // Mobil tidak ditemukan
                    return
                }

                guard let carData = snapshot.value as? [String: Any] else {
                    continuation.resume(throwing: NSError(domain: "FireBaseCarRepository", code: 1002, userInfo: [NSLocalizedDescriptionKey: "Format data mobil berdasarkan ID dari server tidak valid."]))
                    return
                }

                guard let jsonData = try? JSONSerialization.data(withJSONObject: carData),
                      let car = try? JSONDecoder().decode(CarModel.self, from: jsonData) else {
                    continuation.resume(throwing: NSError(domain: "FireBaseCarRepository", code: 1003, userInfo: [NSLocalizedDescriptionKey: "Gagal menguraikan data CarModel untuk ID \(carID)."]))
                    return
                }
                continuation.resume(returning: car)
            } withCancel: { error in
                print("Firebase fetch by ID error: \(error.localizedDescription)")
                continuation.resume(throwing: error) // Langsung teruskan error dari Firebase
            }
        }
    }
}
