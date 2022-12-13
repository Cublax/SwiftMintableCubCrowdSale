//
//  LoginScene.swift
//  CublaxSmartContract
//
//  Created by Meona on 08.06.22.
//

import SwiftUI
import Combine

extension Scenes.Login {
    struct ContentView: View {
        @Binding var viewState: ViewState
        let intentSignIn: (_ credential: URLCredential) -> Void
        let intentDismissError: () -> Void
        
        @SwiftUI.State private var username = ""
        @SwiftUI.State private var password = ""
        
        private enum Field: Int, Hashable {
            case username, password
        }
        @FocusState private var focusedField: Field?
        
        var body: some View {
            let presentAlert = Binding<Bool>(
                get: { self.viewState.error != nil },
                set: { _ in intentDismissError() }
            )
            
            VStack {
                Form {
                    Section(header: Text("Credential")) {
                        TextField("Name", text: $username)
                            .focused($focusedField, equals: .username)
                            .textContentType(.username)
                            .keyboardType(.default)
                            .disableAutocorrection(true)
                            .autocapitalization(.none)
                            .onAppear {
                                username = viewState.privateKey
                            }
                        
                        SecureField("Password", text: $password)
                            .focused($focusedField, equals: .password)
                            .textContentType(.password)
                            .onAppear {
                                password = viewState.password
                            }
                    }
                }
                Button("Sign-In") {
                    focusedField = nil
                    intentSignIn(URLCredential(user: username,
                                               password: password,
                                               persistence: .none))
                }
                .padding()
            }
            .loading(viewState.isLoading)
            .alert(viewState.error?.getErrorMessage() ?? "",
                   isPresented: presentAlert) {
                Button("OK", role: .cancel) {
                    intentDismissError()
                }
            }
            .navigationBarTitle("Sign-In")
        }
    }
}

// MARK: - LoginModifier

struct LoginModifier: ViewModifier {
    
    let isPresented: Binding<Bool>
    let store: Scenes.Login.LoginStore
    
    func body(content: Content) -> some View {
        content
            .fullScreenCover(isPresented: isPresented) {
                Scenes.Login.ComponentView(store: store)
            }
            .navigationTitle("Sign-In")
    }
}

extension View {
    func login(isPresented: Binding<Bool>, presenting store: Scenes.Login.LoginStore) -> some View {
        return modifier(LoginModifier(isPresented: isPresented, store: store))
    }
}

extension Scenes.Login {
    struct ComponentView: View {
        typealias ContentView = Scenes.Login.ContentView
        @StateObject private var viewModel: ViewModel
        
        init(store: LoginStore) {
            _viewModel = StateObject(wrappedValue: ViewModel(store: store))
        }
        var body: some View {
            ContentView(
                viewState: $viewModel.viewState,
                intentSignIn: viewModel.intentSignIn,
                intentDismissError: viewModel.intentDismissError
            )
        }
    }
}

//struct LoginScene_Previews: PreviewProvider {
//    static var previews: some View {
//        let state: Scenes.Login.ViewState = .init()
//        Scenes.Login.ContentView(
//            initialPrivateKey: state.privateKey,
//            initialPassword: state.password,
//            send: { _ in }
//        )
//    }
//}
