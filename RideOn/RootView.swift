//
//  RootView.swift
//  RideOn
//
//  Created by Wojciech Prabucki on 15/11/2025.
//

// RootView.swift
import SwiftUI

struct RootView: View {
    // Wstrzykujemy AuthViewModel jako StateObject
    @StateObject private var authViewModel = AuthViewModel()
    
    var body: some View {
        // Kontrola, który widok wyświetlić na podstawie stanu logowania
        if authViewModel.isAuthenticated {
            ContentView() // Twoja aplikacja z TabView (jeśli zalogowany)
                .environmentObject(authViewModel)
        } else {
            LoginRegisterView(viewModel: authViewModel) // Ekran logowania
                .environmentObject(authViewModel)
        }
    }
}
