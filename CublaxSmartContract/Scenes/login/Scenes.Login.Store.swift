//
//  Scenes.Login.Store.swift
//  CublaxSmartContract
//
//  Created by Meona on 17.06.22.
//

import Foundation

extension Scenes.Login.LoginSceneViewModel {
    
    enum Event {
        case epsilon
        case intentSignIn
    }
    
    enum State {
        case start
        case signInPrompt(credential: URLCredential)
        case signingIn(credential: URLCredential)
        case signedIn
        
        init() {
            self = .start
        }
        
        var privateKey: String {
            switch self {
            case .start:
                return "f67e3244100be4de079f73a586ccc1d5b1b69442dfb7db20178cd1f9f41d9483"
            default:
                return ""
            }
        }
        
        var password: String {
            switch self {
            case .start:
                return "Ninik7474"
            default:
                return ""
            }
        }
        
        var error: Swift.Error? {
            switch self {
            default:
                return nil
            }
        }
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
    
    func update(_ state: State, event: Event) -> (State, [Effect]) {
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
}
