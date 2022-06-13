//
//  LoginScene.swift
//  CublaxSmartContract
//
//  Created by Meona on 08.06.22.
//

import SwiftUI
import Combine

public enum LoginScene {}

extension LoginScene {
    struct ContentView: View {
        @StateObject private var viewModel = LoginSceneViewModel()
        
        var body: some View {
            NavigationView {
                Form {
                    Section {
                        Toggle("Create New Account",
                               isOn: $viewModel.viewState.creatingAccount)
                        if !viewModel.viewState.creatingAccount {
                            TextField("Public Key",
                                      text: $viewModel.viewState.publicKey)
                        }
                        SecureField("Enter password",
                                    text: $viewModel.viewState.password)
                    }
                    Section {
                        Menu(viewModel.viewState.selectedNetwork.userTitle()) {
                            Button("MainNet") {
                                viewModel.updateNetwork(network: .mainNet)
                            }
                            Button("Ropsten") {
                                viewModel.updateNetwork(network: .ropsten)
                            }
                            Button("Rinkeby") {
                                viewModel.updateNetwork(network: .rinkeby)
                            }
                        }
                    }
                    Button("Login",
                           action: viewModel.confirmSelection)
                    .foregroundColor(.black)
                    .frame(minWidth: 0,
                           maxWidth: .infinity,
                           minHeight: 0,
                           maxHeight: .infinity,
                           alignment: .center)
                }.navigationBarTitle("Login")
            }.navigationViewStyle(StackNavigationViewStyle())
        }
    }
}

struct LoginScene_Previews: PreviewProvider {
    static var previews: some View {
        LoginScene.ContentView()
    }
}
