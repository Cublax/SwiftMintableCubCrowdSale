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
        case web3Error(Web3Error)
    }
    
    enum State {
        case start
        case readingContext
        case signInPrompt(_ withContext: URLCredential?)
        case signingIn(_ credential: URLCredential)
        case present(_ credential: URLCredential, Web3Error)
        case signedIn
    }
    
    static func readContext() -> AnyPublisher<Event, Never> {
        Just(Event.start(contextCredential: URLCredential(
            user: "12dd3d149cb77bc52df41f0a6f4ae24896b3a166ddfd5092f2f5d13f9f3a0eb1",
            password: "Cublax.74",
            persistence: .none
        ))).eraseToAnyPublisher()
    }
    
    static func signingRequest(service: Web3Manager, credential: URLCredential) -> AnyPublisher<Event, Never> {
        Future { promise in
            Task {
                do {
                    try await service.setup(password: credential.password ?? "",
                                            privateKey: credential.user ?? "")
                    promise(.success(.signedIn))
                } catch {
                    promise(.success(.web3Error(.initializeWallet(error))))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    static func loginReducer(
        state: inout State,
        event: Event,
        environment: World
    ) -> AnyPublisher<Event, Never> {
        switch (state, event) {
        case (.start, .epsilon):
            state = .readingContext
            return readContext()
            
        case (.readingContext, .start(let credential)):
            state = .signInPrompt(credential)
            
        case (.signInPrompt, .intentSignIn(let credential)):
            state = .signingIn(credential)
            return signingRequest(service: environment.service,
                                  credential: credential)
            
        case (.signingIn, .signedIn):
            state = .signedIn
            
        case (.signingIn(let credential), .web3Error(let error)):
            state = .present(credential, error)
            
        case (.present(let credential, _), .intentDismissError):
            state = .signInPrompt(credential)
            
        default:
            break
        }
        return Empty().eraseToAnyPublisher()
    }
    
    typealias World = Scenes.Main.World
    typealias LoginStore = Store<State, Event, World>
}
