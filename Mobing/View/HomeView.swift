//
//  HomeView.swift
//  Mobing
//
//  Created by Daffa Khoirul on 23/05/25.
//

import SwiftUI

struct HomeView: View {
    @State private var selectedQuizType: String = ""
    let cornerRadius: CGFloat = 30
    @EnvironmentObject var authVM: AuthViewModel
    @Environment(\.dismiss) var dismiss
    @Binding var showLogin: Bool
    var body: some View {
        VStack{
            Text("\(authVM.user?.uid ?? "No User")")
                .font(.title)
            Button(action: {
                self.authVM.signOut()
                showLogin = true
                dismiss()
            }) {
                Text("Sign Out")
            }
        }
    }
}

//#Preview {
//    HomeView()
//        .environmentObject(AuthViewModel(repository: FirebaseAuthRepository()))
//}
