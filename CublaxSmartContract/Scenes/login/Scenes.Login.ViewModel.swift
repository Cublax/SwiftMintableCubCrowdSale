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
    @MainActor
    final class ViewModel: ObservableObject {
        @Published var viewState = ViewState.init()
        
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
        
        nonisolated func intentSignIn(credential: URLCredential) {
            store.send(.intentSignIn(credential: credential))
        }
        
        nonisolated func intentDismissError() {
            store.send(.intentDismissError)
        }
        
        private func view(_ output: State) -> ViewState {
            switch output {
            case .start:
                return .init(privateKey: "",
                             password: "")
                
            case .signInPrompt(withContext: let credentials):
                return .init(privateKey: credentials?.user ?? "",
                             password: credentials?.password ?? "")
                
            case .signingIn(let credentials):
                return .init(privateKey: credentials.user ?? "",
                             password: credentials.password ?? "",
                             isLoading: true)
                
            case .present(let credentials, let error):
                return .init(privateKey: credentials.user ?? "",
                             password: credentials.password ?? "",
                             error: error)
                
            case .readingContext:
                return .init(isLoading: true)
                
            case .signedIn:
                return .init()
            }
        }
    }
}
