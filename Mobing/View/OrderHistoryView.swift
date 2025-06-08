//
//  OrderHistoryView.swift
//  Mobing
//
//  Created by Surya on 07/06/25.
//

import SwiftUI

struct OrderHistoryView: View {
    @StateObject private var viewModel = OrderViewModel()
    @EnvironmentObject var authViewModel : AuthViewModel

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
                   viewModel.loadMySoldOrders(currentUserId: authViewModel.user?.uid ?? "")
               }
           }
       }
}

#Preview {
    OrderHistoryView()
}
