//
//  Scenes.TokenSale.Store.swift
//  CublaxSmartContract
//
//  Created by Meona on 28.06.22.
//

import Foundation

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
    
    final class Store: ObservableObject {
        
        @Published var state: State
        @Published var event: Event
        
        init(state: State, event: Event) {
            self.state = state
            self.event = event
        }
    }
}
