//
//  LoginScene.ViewModel.swift
//  CublaxSmartContract
//
//  Created by Meona on 13.06.22.
//

import Foundation
import SwiftUI
import Combine

extension Scenes.Login {
    struct ViewState {
        var privateKey = ""
        var password = ""
        var error: Swift.Error?
    }
}

extension Scenes.Login {
    final class LoginSceneViewModel: ObservableObject {
        @Published var viewState = ViewState.init()
        @Published var internalState: State = .init()
        private var web3: Web3Manager!
        
        let store: Store
        private var cancellable: AnyCancellable?
        
        init(store: Store) {
            self.store = store
            cancellable = $internalState.sink(receiveValue: { state in
                store.state = state
            })
            send(.epsilon)
            
        }
        
        struct Effect {
            init(_ f: @escaping @Sendable () -> Void) {
                self.f = f
            }
            private let f: () -> Void
            func invoke() {
                f()
            }
        }
        
        func send(_ event: Event) {
            let (newInternalState, effects) = update(self.internalState, event: event)
            self.internalState = newInternalState
            self.viewState = transform(internalState: newInternalState)
            effects.forEach { effect in
                effect.invoke()
            }
        }
        
        private func update(_ state: State, event: Event) -> (State, [Effect]) {
            switch (state, event) {
            case (.start, .epsilon):
                return (
                    .signInPrompt(
                        credential: URLCredential(
                            user: state.privateKey,
                            password: state.password,
                            persistence: .none
                        )
                    ), [Effect{
                        self.send(.start)
                    }])
                
            case (.signInPrompt(credential: let credentials), .start):
                print(credentials)
                viewState.privateKey = credentials.user ?? ""
                viewState.password = credentials.password ?? ""
                return (state,[])
                
            case (.signInPrompt(credential: _), .intentSignIn(credential: let credentials)):
                return (.signingIn(credential: credentials), [Effect {
                    Task {
                        do {
                            self.web3 = await Web3Manager(password: credentials.password!,
                                                          privateKey: credentials.user)
                            self.send(.signedIn)
                        }
                    }
                }])
                
            case (.signingIn(credential: _), .signedIn):
                print("Sign in success")
                return (.signedIn,[Effect {
                    self.send(.signedIn)
                }])
                
            case (.signedIn, .signedIn):
                print("Triger View Transition")
                return (state,[])
                
            default:
                print("did not handle \(state) \(event)")
                return (state,[])
            }
        }
        
        private func transform(internalState: State) -> ViewState {
            ViewState.init(privateKey: internalState.privateKey,
                           password: internalState.password,
                           error: internalState.error)
        }
    }
}
