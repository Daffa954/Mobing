//
//  OrderRepository.swift
//  Mobing
//
//  Created by Daffa Khoirul on 01/06/25.
//

import Foundation
import FirebaseDatabase

class FireBaseOrderRepository {
    private let ref: DatabaseReference
    
    init() {
        self.ref = Database.database().reference().child("orders")
    }
    
    func createOrder(order: OrderModel, completion: @escaping (Error?) -> Void) {
        let orderDict: [String: Any] = [
            "id": order.id.uuidString,
            "userId": order.userId,
            "carId": order.carId,
            "sellerId": order.sellerId,
            "date": ISO8601DateFormatter().string(from: order.date),
            "totalPrice": order.totalPrice,
            "address": order.address,
            "phone": order.phone,
            "name" : order.name
        ]
        
        let carRef = Database.database().reference().child("cars").child(String(order.carId))
        
        // Langkah 1: Cek status isAvailable
        
        carRef.observeSingleEvent(of: .value) { snapshot in
            guard let carData = snapshot.value as? [String: Any],
                  let isSold = carData["isSold"] as? Bool else {
                completion(NSError(domain: "Firebase", code: 404, userInfo: [NSLocalizedDescriptionKey: "Car not found or invalid data."]))
                return
            }
            
            guard !isSold else {
                completion(NSError(domain: "Firebase", code: 400, userInfo: [NSLocalizedDescriptionKey: "Stok Kosong"]))
                return
            }
            
            // Lanjutkan proses order jika mobil belum terjual
            self.ref.child(order.id.uuidString).setValue(orderDict) { error, _ in
                if let error = error {
                    completion(error)
                    return
                }

                // Update status mobil menjadi terjual
                carRef.updateChildValues(["isSold": true]) { carError, _ in
                    completion(carError)
                }
            }
        }
    }
    
    func fetchSoldOrdersByUser(userId: String, completion: @escaping ([OrderModel]) -> Void) {
        ref.observeSingleEvent(of: .value) { snapshot in
            var soldOrders: [OrderModel] = []

            guard let ordersDict = snapshot.value as? [String: [String: Any]] else {
                completion([])
                return
            }

            let group = DispatchGroup()

            for (_, orderData) in ordersDict {
                if let fetchedUserId = orderData["userId"] as? String, fetchedUserId == userId,
                   let idString = orderData["id"] as? String,
                   let carId = orderData["carId"] as? Int,
                   let sellerId = orderData["sellerId"] as? Int,
                   let dateString = orderData["date"] as? String,
                   let date = ISO8601DateFormatter().date(from: dateString),
                   let totalPrice = orderData["totalPrice"] as? Double,
                   let address = orderData["address"] as? String,
                   let phone = orderData["phone"] as? String,
                   let name = orderData["name"] as? String {

                    group.enter()
                    let carRef = Database.database().reference().child("cars").child(String(carId))

                    carRef.observeSingleEvent(of: .value) { carSnapshot in
                        defer { group.leave() }

                        if let carData = carSnapshot.value as? [String: Any],
                           let isSold = carData["isSold"] as? Bool, isSold == true {

                            let order = OrderModel(
                                id: UUID(uuidString: idString) ?? UUID(),
                                userId: fetchedUserId,
                                carId: carId,
                                sellerId: sellerId,
                                date: date,
                                totalPrice: totalPrice,
                                address: address,
                                phone: phone,
                                name: name
                            )
                            soldOrders.append(order)
                        }
                    }
                }
            }

            group.notify(queue: .main) {
                completion(soldOrders)
            }
        }
    }
}
