//
//  OrderHistoryCardView.swift
//  Mobing
//
//  Created by Surya on 07/06/25.
//
import SwiftUI

struct OrderHistoryCardView: View {
    let order: OrderModel

    var body: some View {
        ZStack {
            // You can add background layers or effects here if you want.
            
            VStack(alignment: .leading, spacing: 12) {
                // Order Title
                Text(order.name)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.cyan)
                    .padding(.top)

                // Order Details
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Image(systemName: "calendar")
                        Text("Date: \(order.date.formatted(date: .abbreviated, time: .omitted))")
                    }

                    HStack {
                        Image(systemName: "mappin.and.ellipse")
                        Text("Address: \(order.address)")
                    }

                    HStack {
                        Image(systemName: "phone.fill")
                        Text("Phone: \(order.phone)")
                    }

                    HStack {
                        Image(systemName: "dollarsign.circle.fill")
                        Text("Total: $\(order.totalPrice, specifier: "%.2f")")
                    }
                }
                .font(.subheadline)
                .foregroundColor(.white)
                .padding(.bottom)

            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.black.opacity(0.85))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.cyan, lineWidth: 1)
            )
            .shadow(color: .cyan.opacity(0.3), radius: 10, x: 0, y: 5)
            .padding(.horizontal)
        }
        .frame(maxWidth: .infinity)  // Make ZStack itself full width too
    }
}
