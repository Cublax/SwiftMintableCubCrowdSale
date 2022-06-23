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
        let viewState: ViewState
        let send: (_: Event) -> Void

        @SwiftUI.State private var username = ""
        @SwiftUI.State private var password = ""
        
        private enum Field: Int, Hashable {
            case username, password
        }
        @FocusState private var focusedField: Field?
        
        var body: some View {
            VStack {
                Form {
                    Section(header: Text("Credential")) {
                        TextField("Name", text: $username)
                            .focused($focusedField, equals: .username)
                            .textContentType(.username)
                            .keyboardType(.default)
                            .disableAutocorrection(true)
                            .autocapitalization(.none)
                        
                        SecureField("Password", text: $password)
                            .focused($focusedField, equals: .password)
                            .textContentType(.password)
                    }
                }
                Button("Sign-In") {
                    focusedField = nil
                    send(.intentSignIn(
                        credential: .init(user: username, password: password, persistence: .none))
                    )
                }
                //                .buttonStyle(.)
                .padding()
            }
            .navigationBarTitle("Sign-In")
        }
    }
}
extension Scenes.Login {
    struct ComponentView: View {
        typealias ContentView = Scenes.Login.ContentView
        @StateObject private var viewModel = LoginSceneViewModel()
        
        var body: some View {
            ContentView(
                viewState: viewModel.viewState,
                send: viewModel.send)
        }
    }
}

struct LoginScene_Previews: PreviewProvider {
    static var previews: some View {
        let state: Scenes.Login.ViewState = .init()
        Scenes.Login.ContentView(viewState: state,
                                 send: { _ in })
    }
}
