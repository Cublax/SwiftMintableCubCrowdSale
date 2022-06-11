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
    struct ViewState {
        var creatingAccount = false
        var selectedNetwork: Network = .none
        var privateKey = ""
        var password = ""
        var error: Swift.Error?
    }
}

extension LoginScene {
    enum Network {
        case none
        case mainNet
        case ropsten
        case rinkeby
        
        func userTitle() -> String {
            switch self {
            case .none:
                return "Please select network"
            case .mainNet:
                return "Main Net"
            case .ropsten:
                return "Ropsten"
            case .rinkeby:
                return "Rinkeby"
            }
        }
    }
}

extension LoginScene {
    final class LoginSceneViewModel: ObservableObject {
        
        @Published var viewState = ViewState.init()
        
        func updateNetwork(network: Network) {
            self.viewState.selectedNetwork = network
        }
        
        func confirmSelection() {
        }
        
        private func createAccount(password: String) {}
        private func performLogin(password: String) {}
    }
}

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
                            TextField("Private Key",
                                      text: $viewModel.viewState.privateKey)
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
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
                }.navigationBarTitle("Login")
                
            }
        }
    }
}

struct LoginScene_Previews: PreviewProvider {
    static var previews: some View {
        LoginScene.ContentView()
    }
}
