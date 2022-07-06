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
        
        // Intents, sent from the UI
        case intentSignIn(credential: URLCredential)
        case intentDismissError
        
        // Effect Outputs
        case start(contextCredential: URLCredential)
        case signedIn
        case signinError(error: Swift.Error)
    }
    
    enum State {
        case start
        case readingContext
        case signInPrompt(withContext: URLCredential?)
        case signingIn
        case signinFailure(Swift.Error)
        case signedIn
    }
    
    static func readContext() -> AnyPublisher<Event, Never> {
        return Just(Event.start(contextCredential: URLCredential(
            user: "12dd3d149cb77bc52df41f0a6f4ae24896b3a166ddfd5092f2f5d13f9f3a0eb1",
            password: "Cublax.74",
            persistence: .none
        ))).eraseToAnyPublisher()
    }
    
    static func signingRequest(service: Web3Manager, credential: URLCredential) -> AnyPublisher<Event, Never> {
        Future { promise in
            Task {
                let loginEvent = await service.setup(password: credential.password ?? "",
                                                     privateKey: credential.user)
                promise(Result.success(loginEvent))
            }
        }.eraseToAnyPublisher()
    }
    
    static func loginReducer(
        state: inout State,
        event: Event,
        environment: World
    ) -> AnyPublisher<Event, Never> {
        switch event {
        case .epsilon:
            state = .readingContext
            return readContext()
            
        case .start(let credentials):
            state = .signInPrompt(withContext: credentials)
            
        case .intentSignIn(credential: let credential):
            state = .signingIn
            return signingRequest(service: environment.service,
                                  credential: credential)
            
        case .signedIn:
            state = .signedIn
            
        case .signinError(error: let error):
            state = .signinFailure(error)
            
        case .intentDismissError:
            break
        }
        return Empty().eraseToAnyPublisher()
    }
    
    typealias World = Scenes.Main.World
    typealias LoginStore = Store<State, Event, World>
}
