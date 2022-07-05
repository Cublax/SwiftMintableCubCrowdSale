//
//  LoginScene.ViewModel.swift
//  CublaxSmartContract
//
//  Created by Meona on 13.06.22.
//

import Foundation
import Combine

extension Scenes.Login {
    struct ViewState {
        var privateKey = ""
        var password = ""
        var error: Swift.Error?
    }
}

extension Scenes.Login {
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
        
        func send(_ event: Event) {
            store.send(event)
        }
        
        private func view(_ output: State) -> ViewState {
            switch output {
            case .start:
                return .init()
                
            case .signInPrompt(withContext: let credentials):
                return  .init(privateKey: credentials?.user ?? "",
                              password: credentials?.password ?? "",
                              error: nil)
                
            default:
                return self.viewState
            }
        }
    }
}
