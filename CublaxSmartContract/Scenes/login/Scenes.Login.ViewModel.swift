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
        
        func login() {
            
        }
        
        private func send(_ event: Event) {
            let (newInternalState, effects) = update(self.internalState, event: event)
            self.internalState = newInternalState
            self.viewState = transform(internalState: newInternalState)
            effects.forEach { effect in
                effect.invoke()
            }
        }
        
        private func transform(internalState: State) -> ViewState {
            ViewState.init(privateKey: internalState.privateKey,
                           password: internalState.password,
                           error: internalState.error)
        }
    }
}
