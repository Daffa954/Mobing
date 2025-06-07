//
//  OrderHistoryView.swift
//  Mobing
//
//  Created by Surya on 07/06/25.
//

import SwiftUI

struct OrderHistoryView: View {
    @StateObject private var viewModel = OrderViewModel()

       var body: some View {
           NavigationView {
               ScrollView {
                   LazyVStack(spacing: 16) {
                       ForEach(viewModel.mySoldOrders) { order in
                           OrderHistoryCardView(order: order)
                               .padding(.horizontal)
                       }
                   }
                   .padding(.vertical)
               }
               .navigationTitle("Order History")
               .onAppear {
                   viewModel.loadMySoldOrders(currentUserId: "999") 
               }
           }
       }
}

#Preview {
    OrderHistoryView()
}
