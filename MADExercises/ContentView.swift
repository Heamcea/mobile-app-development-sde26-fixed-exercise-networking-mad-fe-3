//
//  ContentView.swift
//  MADExercises
//
//  Created by Hamza Ahmad
//

import SwiftUI

struct ContentView: View {
    
    @State private var email = ""
    
    @State private var password = ""
    
    @State private var isLoading = false
    
    @State private var alertTitle = ""
    
    @State private var alertMessage = ""
    
    @State private var showAlert = false
    
    private enum Field {
        case email
        case password
    }
    
    @FocusState private var focusedField: Field?
    
    private let expectedEmail = "test@hcw.com"
    private let expectedPassword = "campusWien1100"
    
    var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()
            
            VStack {
                Text("Login")
                    .font(.largeTitle)
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .center)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Email")
                        .font(.headline)
                    
                    TextField("yourmail@example.com", text: $email)
                        .keyboardType(.emailAddress)
                        .textContentType(.emailAddress)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .focused($focusedField, equals: .email)
                        .submitLabel(.next)
                        .onSubmit {
                            focusedField = .password
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray.opacity(0.3))
                        )
                        .disabled(isLoading)
                    
                    Text("Password")
                        .font(.headline)
                    SecureField("Your password", text: $password)
                        .textContentType(.password)
                        .focused($focusedField, equals: .password)
                        .submitLabel(.go)
                        .onSubmit {
                            login()
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray.opacity(0.3))
                        )
                        .disabled(isLoading)
                }
                
                HStack {
                    if isLoading {
                        ProgressView("Loading ...")
                            .progressViewStyle(.circular)
                    } else {
                        Button {
                            login()
                        } label: {
                            Text("Login")
                                .font(.headline)
                                .foregroundColor(.mint)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color.white)
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.mint)
                                )
                                .contentShape(RoundedRectangle(cornerRadius: 10))
                        }
                        .buttonStyle(.plain)
                        .disabled(isLoading)
                    }
                }
            }
            .padding(24)
            .background(Color.white)
            .cornerRadius(20)
            .frame(maxWidth: 440)
            .padding(.horizontal, 16)
            .shadow(color: Color.black.opacity(0.1), radius: 10)
            .alert(alertTitle, isPresented: $showAlert){
                Button("OK", role: .cancel){
                }
            } message: {
                Text(alertMessage)
            }
        }
    }
    
    private func login() {
        guard !isLoading else {
            return
        }
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedEmail.isEmpty else {
            displayAlert("Missing Email", "Please enter an email")
            return
        }
        guard !password.isEmpty else {
            displayAlert("Missing Password", "Please enter a password")
            return
        }
        
        isLoading = true
        focusedField = nil
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            isLoading = false

            if trimmedEmail == expectedEmail && password == expectedPassword {
                displayAlert("Success", "Login successful!")
            } else {
                displayAlert("Failed Login", "Email or Password is incorrect!")
            }
        }
    }
    private func displayAlert(_ title: String,_ message: String){
        alertTitle = title
        alertMessage = message
        showAlert = true
    }
}

#Preview {
    ContentView()
}
