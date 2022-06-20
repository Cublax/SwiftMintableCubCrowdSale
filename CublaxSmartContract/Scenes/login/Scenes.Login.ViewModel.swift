//
//  LoginScene.ViewModel.swift
//  CublaxSmartContract
//
//  Created by Meona on 13.06.22.
//

import Foundation
import SwiftUI

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
        private var internalState: State = .init()
        
        init() {
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
                return (.signInPrompt(
                    credential: URLCredential(
                        user: "f67e3244100be4de079f73a586ccc1d5b1b69442dfb7db20178cd1f9f41d9483",
                        password: "Ninik7474",
                        persistence: .none
                    )
                ), [Effect {
                } ])
                
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
