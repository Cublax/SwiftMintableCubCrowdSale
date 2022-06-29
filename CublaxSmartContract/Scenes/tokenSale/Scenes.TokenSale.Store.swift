//
//  Scenes.TokenSale.Store.swift
//  CublaxSmartContract
//
//  Created by Meona on 28.06.22.
//

import Foundation
import Combine

extension Scenes.TokenSale {
    
    enum Event {
        case epsilon
        case logedIn
        case valuesFetched
    }
    
    enum State {
        case placeHolder
        case fetchingValues
        case valuesFetched
        
        init() {
            self = .placeHolder
        }
        var accountBalance: String {
            switch self {
            case .placeHolder:
                return "0"
            default:
                return ""
            }
        }
        
        var totalTokenSupply: Int {
            switch self {
            case .placeHolder:
                return 0
            default:
                return 0
            }
        }
        
        var tokenBalance: String {
            switch self {
            case .placeHolder:
                return "0"
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
    
    static func tokenSaleReducer(
        state: inout State,
        event: Event,
        environment: World
    ) -> AnyPublisher<Event, Never> {
        switch event {
        case .epsilon:
            state = .placeHolder
            
        case .logedIn:
            state = .fetchingValues
//            return Just(Event.logedIn).eraseToAnyPublisher()

        case .valuesFetched:
            break
        }
        return Empty().eraseToAnyPublisher()
    }
    
    typealias World = Scenes.Main.World
    typealias TokenSaleStore = Store<State, Event, World>
}

