//
//  OrderViewModel.swift
//  Mobing
//
//  Created by Daffa Khoirul on 26/05/25.
//

import Foundation

@MainActor
class OrderViewModel: ObservableObject {
    @Published var orders: [OrderModel] = []
    @Published var errorMessage: String? = nil
    @Published var isLoading: Bool = false
    @Published var orderSuccess: Bool = false // Tambahkan ini

    private let orderRepository: FireBaseOrderRepository
    private let networkManager: NetworkManager
    private let currentUserId = "999" // Simulasi user ID
    
    init(
        orderRepository: FireBaseOrderRepository = FireBaseOrderRepository(),
        networkManager: NetworkManager = NetworkManager()
    ) {
        self.orderRepository = orderRepository
        self.networkManager = networkManager
    }
    
    func createOrder(carId: Int, sellerId: Int, totalPrice: Double, address: String, phone: String, date: Date, name : String) {
        errorMessage = nil
        
        guard networkManager.isConnected else {
            errorMessage = "Tidak bisa membuat order. Tidak ada koneksi internet."
            print("❌ \(errorMessage!)")
            return
        }
        
        isLoading = true
        
        let newOrder = OrderModel(
            id: UUID(),
            userId: currentUserId,
            carId: carId,
            sellerId: sellerId,
            date: date,
            totalPrice: totalPrice,
            address: address,
            phone: phone,
            name: name
            
        )
        
        orderRepository.createOrder(order: newOrder) { error in
            DispatchQueue.main.async {
                self.isLoading = false
                if let error = error {
                    self.errorMessage = error.localizedDescription
                    self.orderSuccess = false // Pastikan success false saat error
                } else {
                    self.orders.append(newOrder)
                    self.errorMessage = nil
                    self.orderSuccess = true // Set success true
                }
            }
        }
    }
}
