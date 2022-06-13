//
//  LoginScene.ViewModel.swift
//  CublaxSmartContract
//
//  Created by Meona on 13.06.22.
//

import Foundation

extension LoginScene {
    struct ViewState {
        var creatingAccount = false
        var selectedNetwork: Network = .none
        var publicKey = ""
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
            if viewState.creatingAccount {
                createAccount(
                    password: viewState.password
                )
            } else {
                performLogin(
                    publicKey: viewState.publicKey,
                    password: viewState.password
                )
            }
        }
        
        private func createAccount(password: String) {
            
        }
        private func performLogin(publicKey: String, password: String) {
            
        }
    }
}
