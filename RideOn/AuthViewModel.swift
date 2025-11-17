//
//  AuthViewModel.swift
//  RideOn
//
//  Created by Wojciech Prabucki on 15/11/2025.
//

// AuthViewModel.swift
import Foundation
import FirebaseAuth // Wymagane
import Combine

final class AuthViewModel: ObservableObject {
    
    // PUBLISHED: Kluczowy stan kontrolujący nawigację
    @Published var isAuthenticated: Bool = false
    @Published var email = ""
    @Published var password = ""
    @Published var errorMessage: String?
    @Published var isLoading = false
    
    private var authHandle: AuthStateDidChangeListenerHandle?
    
    init() {
        // Nasłuchiwanie zmian stanu autoryzacji Firebase
        authHandle = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            DispatchQueue.main.async {
                self?.isAuthenticated = (user != nil)
            }
        }
    }
    
    // MARK: - Akcje
    
    func login() {
        isLoading = true
        errorMessage = nil
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] _, error in
            defer { self?.isLoading = false }
            if let error = error {
                self?.errorMessage = error.localizedDescription
                self?.isAuthenticated = false
            } else {
                // Sukces: isAuthenticated zostanie ustawione przez listener
            }
        }
    }
    
    func register() {
        isLoading = true
        errorMessage = nil
        
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] _, error in
            defer { self?.isLoading = false }
            if let error = error {
                self?.errorMessage = error.localizedDescription
            } else {
                // Sukces: isAuthenticated zostanie ustawione przez listener
                // Opcjonalnie: automatyczne zalogowanie po rejestracji
            }
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
        } catch let signOutError as NSError {
            self.errorMessage = signOutError.localizedDescription
        }
    }
}
