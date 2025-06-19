//
//  SplashScreenView.swift
//  Mobing
//
//  Created by Daffa Khoirul on 29/05/25.
//

import Foundation
import SwiftUI

struct SplashScreenView: View {
    @State private var isActive = false

    var body: some View {
        if isActive {
            MainView()
        } else {
            VStack {
                HStack {
                    Text("The future of \n second hand \n electric car")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    Spacer()
                }.padding(.leading, 12)
                    .padding(.top, 90)

                //show me the image of a car from my asset called "tesla mobil "

                GeometryReader { geometry in
                    Image("tesla mobil")
                        .resizable()
                        .scaledToFill()
                        .frame(
                            width: geometry.size.width,
                        )
                        .offset(x: -200, y:100)
                        .clipped()
                        
                }
                .frame(height: 500)
                

                Spacer()
                Text("By UD Maju Sentosa")
                    .font(.callout)
                    .fontWeight(.medium)
                    .padding(.bottom, 50)
                    .foregroundColor(.white)

            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.black)
            .ignoresSafeArea()
            .onAppear {
                // Waktu tampil splash screen dalam detik
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.4) {
                    withAnimation {
                        self.isActive = true
                    }
                }
            }
        }
    }
}

#Preview {
    SplashScreenView()
        .environmentObject(
            AuthViewModel(repository: FirebaseAuthRepository())
        )
}
