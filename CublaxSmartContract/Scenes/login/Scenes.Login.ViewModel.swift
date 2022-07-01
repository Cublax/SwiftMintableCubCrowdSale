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
//                return .init(privateKey: "private key test",
//                             password: "",
//                             error: nil)
            case .signInPrompt(credential: let credentials):
                return  .init(privateKey: credentials.user ?? "",
                              password: credentials.password ?? "",
                              error: nil)
                
            default:
                return self.viewState
            }
        }
        
        //        private func update(_ state: inout State, event: Event) -> [Effect] {
        //            switch (state, event) {
        //            case (.start, .epsilon):
        //                state = .signInPrompt(
        //                    credential: URLCredential(
        //                        user: state.privateKey,
        //                        password: state.password,
        //                        persistence: .none
        //                    ))
        //                return [Effect{
        //                    self.send(.start)
        //                }]
        //
        //            case (.signInPrompt(credential: let credentials), .start):
        //                print(credentials)
        //                viewState.privateKey = credentials.user ?? ""
        //                viewState.password = credentials.password ?? ""
        //
        //                return []
        //
        //            case (.signInPrompt(credential: _), .intentSignIn(credential: let credentials)):
        //                state = .signingIn(credential: credentials)
        //                return [Effect {
        //                    Task {
        //                        do {
        //                            await self.web3.setup(password: credentials.password!,
        //                                             privateKey: credentials.user)
        //                            self.send(.signedIn)
        //                        }
        //                    }
        //                }]
        //
        //            case (.signingIn(credential: _), .signedIn):
        //                print("Sign in success")
        //                state = .signedIn
        //                return [Effect {
        //                    self.send(.signedIn)
        //                }]
        //
        //            case (.signedIn, .signedIn):
        //                print("Triger View Transition")
        //                return []
        //
        //            default:
        //                print("did not handle \(state) \(event)")
        //                return []
        //            }
        //        }
        //    }
    }
}
