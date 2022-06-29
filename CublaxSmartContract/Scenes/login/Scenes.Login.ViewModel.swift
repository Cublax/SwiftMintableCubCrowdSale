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
            let effects = update(&internalState, event: event)
            self.viewState = transform(internalState: internalState)
            effects.forEach { effect in
                effect.invoke()
            }
        }
        
        private func update(_ state: inout State, event: Event) -> [Effect] {
            switch (state, event) {
            case (.start, .epsilon):
                state = .signInPrompt(
                    credential: URLCredential(
                        user: state.privateKey,
                        password: state.password,
                        persistence: .none
                    ))
                return [Effect{
                    self.send(.start)
                }]
                
            case (.signInPrompt(credential: let credentials), .start):
                print(credentials)
                viewState.privateKey = credentials.user ?? ""
                viewState.password = credentials.password ?? ""
                
                return []
                
            case (.signInPrompt(credential: _), .intentSignIn(credential: let credentials)):
                state = .signingIn(credential: credentials)
                return [Effect {
                    Task {
                        do {
                            await self.web3.setup(password: credentials.password!,
                                             privateKey: credentials.user)
                            self.send(.signedIn)
                        }
                    }
                }]
                
            case (.signingIn(credential: _), .signedIn):
                print("Sign in success")
                state = .signedIn
                return [Effect {
                    self.send(.signedIn)
                }]
                
            case (.signedIn, .signedIn):
                print("Triger View Transition")
                return []
                
            default:
                print("did not handle \(state) \(event)")
                return []
            }
        }
        
        private func transform(internalState: State) -> ViewState {
            ViewState.init(privateKey: internalState.privateKey,
                           password: internalState.password,
                           error: internalState.error)
        }
    }
}
