//
//  FireStoreManager.swift
//  PomeloNewYorkTimes
//
//  Created by Chaiyatat Saiphin on 24/3/2565 BE.
//

import Foundation
import FirebaseFirestore

final class FirestoreManager {
    static let shared: FirestoreManager = FirestoreManager()
    private var apiKey: String = ""
    
    func getConfig(onSuccess: @escaping () -> Void) {
        let fireStore = Firestore.firestore()
        fireStore.collection("exampleKeys").document("keys").addSnapshotListener { (documentSnapshot, error) in
            guard let document = documentSnapshot else { return }
            guard let data = document.data() else { return }
            guard let apiKey = data["apiKey"] as? String else { return }
            self.apiKey = apiKey
            onSuccess()
        }
    }
    
    func getApiKey() -> String {
        return self.apiKey
    }
}
