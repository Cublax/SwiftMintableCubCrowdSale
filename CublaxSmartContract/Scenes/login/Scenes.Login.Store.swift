//
//  Scenes.Login.Store.swift
//  CublaxSmartContract
//
//  Created by Meona on 17.06.22.
//

import Foundation
import Combine

extension Scenes.Login {
    
    enum Event {
        case epsilon
        case start
        case intentSignIn(credential: URLCredential)
        case signedIn
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
    
    final class OldStore: ObservableObject {
        
        @Published var state: State
        @Published var event: Event
        
        init(state: State, event: Event) {
            self.state = state
            self.event = event
        }
    }
    
    static func loginReducer(
        state: inout State,
        event: Event,
        environment: World
    ) -> AnyPublisher<Event, Never> {
        switch event {
        case .epsilon:
            break
        case .start:
            break
        case .intentSignIn(credential: let credential):
            break
        case .signedIn:
            break
        }
        return Empty().eraseToAnyPublisher()
    }
    
    typealias World = Scenes.Main.World
    typealias LoginStore = Store<State, Event, World>
}
