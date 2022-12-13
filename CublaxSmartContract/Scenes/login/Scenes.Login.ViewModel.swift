//
//  LoginScene.ViewModel.swift
//  CublaxSmartContract
//
//  Created by Meona on 13.06.22.
//

import Foundation
import Combine
import SwiftUI

extension Scenes.Login {
    enum ViewState {
        case editing(privateKey: String, password: String)
        case showingError(Web3Error)
        case loading
        
        var privateKey: String {
            switch self {
            case .editing(let privateKey, _):
                return privateKey
            default:
                return ""
            }
        }
        
        var password: String {
            switch self {
            case .editing(_, let password):
                return password
            default:
                return ""
            }
        }
        
        var isLoading: Bool {
            switch self {
            case .loading:
                return true
            default:
                return false
            }
        }
        
        var error: Web3Error? {
            switch self {
            case .showingError(let error):
                return error
            default:
                return nil
            }
        }
    }
}

extension Scenes.Login {
    final class ViewModel: ObservableObject {
        @Published var viewState = ViewState.editing(privateKey: "", password: "")
        
        let store: Scenes.Login.LoginStore
        private var cancellable: AnyCancellable?
        
        init(store: Scenes.Login.LoginStore) {
            self.store = store
            cancellable = store.$state.sink(receiveValue: { output in
                self.viewState = self.view(output)
            })
        }
        
        private func send(_ event: Event) {
            store.send(event)
        }
        
        func intentSignIn(credential: URLCredential) {
            store.send(.intentSignIn(credential: credential))
        }
        
        func intentDismissError() {
            store.send(.intentDismissError)
        }
        
        private func view(_ output: State) -> ViewState {
            switch output {
            case .start:
                return .editing(privateKey: "", password: "")
                
            case .signInPrompt(withContext: let credentials):
                return .editing(privateKey: credentials?.user ?? "",
                                password: credentials?.password ?? "")
                
            case .signingIn:
                return .loading
                
            case .present(let error):
                return .showingError(error)
                
            default:
                return .editing(privateKey: "", password: "")
            }
        }
    }
}
