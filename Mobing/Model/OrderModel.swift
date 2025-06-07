//
//  OrderModel.swift
//  Mobing
//
//  Created by Daffa Khoirul on 26/05/25.
//

import Foundation

struct OrderModel: Identifiable, Hashable, Codable {
    var id = UUID()
    var userId: String
    var carId: Int
    var sellerId: Int
    var date: Date
    var totalPrice: Double
    var address: String
    var phone: String
    var name : String
}

