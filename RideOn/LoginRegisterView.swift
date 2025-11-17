//
//  LoginRegisterView.swift
//  RideOn
//
//  Created by Wojciech Prabucki on 15/11/2025.
//

// LoginRegisterView.swift
import SwiftUI

struct LoginRegisterView: View {
    @ObservedObject var viewModel: AuthViewModel
    @State private var isRegistering = false
    
    var body: some View {
        VStack(spacing: 25) {
            
            Text("RideOn")
                .font(.system(size: 48, weight: .black))
                .foregroundColor(.green)
            
            VStack(spacing: 15) {
                TextField("Email", text: $viewModel.email)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .textFieldStyle(.roundedBorder)
                
                SecureField("Hasło", text: $viewModel.password)
                    .textFieldStyle(.roundedBorder)
                
                if let error = viewModel.errorMessage {
                    Text(error).foregroundColor(.red).font(.caption)
                }
            }
            
            // Przycisk Akcji
            Button {
                if isRegistering {
                    viewModel.register()
                } else {
                    viewModel.login()
                }
            } label: {
                if viewModel.isLoading {
                    ProgressView()
                } else {
                    Text(isRegistering ? "Zarejestruj się" : "Zaloguj się")
                        .frame(maxWidth: .infinity)
                }
            }
            .buttonStyle(.borderedProminent)
            .tint(isRegistering ? .orange : .green)
            
            // Przełączanie między Logowaniem a Rejestracją
            Button(isRegistering ? "Masz już konto? Zaloguj się" : "Stwórz konto") {
                isRegistering.toggle()
                viewModel.errorMessage = nil
            }
            .font(.caption)
            .foregroundColor(.secondary)
        }
        .padding(40)
    }
}

