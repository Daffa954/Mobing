//
//  AuthRepository.swift
//  Mobing
//
//  Created by Daffa Khoirul on 23/05/25.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase
import Foundation
import FirebaseAuth



class FirebaseAuthRepository {
    func signIn(email: String, password: String) async throws -> AuthDataResult {
        return try await Auth.auth().signIn(withEmail: email, password: password)
    }
    
    func signUp(email: String, password: String) async throws -> AuthDataResult {
        return try await Auth.auth().createUser(withEmail: email, password: password)
    }

    func fetchUserProfile(userID: String) async throws -> UserModel {
        let ref = Database.database().reference().child("users").child(userID)
        let snapshot = try await ref.getData()
        
        guard let value = snapshot.value as? [String: Any] else {
            throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid user data"])
        }

        return UserModel(
            id: value["id"] as? String ?? "",
            username: value["name"] as? String ?? "",
            email: value["email"] as? String ?? ""

        )
    }

    func saveUserProfile(user: UserModel) async throws {
        let ref = Database.database().reference().child("users").child(user.id)
        let userData: [String: Any] = [
            "id": user.id,
            "email": user.email,
            "username": user.username,
            "listOrders": user.listOrders.isEmpty ? [""] : user.listOrders
        ]
        try await ref.setValue(userData)
    }

    func signOut() throws {
        try Auth.auth().signOut()
    }

    func getCurrentUser() -> User? {
        return Auth.auth().currentUser
    }
}
