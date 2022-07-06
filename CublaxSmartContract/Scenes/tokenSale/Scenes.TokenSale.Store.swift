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
        // Intents, sent from the UI
        
        // Effect Outputs
        case logedIn
        case receivedValues(accountBalance: String, totalTokenSupply: Int, tokenBalance: String)
        case fetchingError(error: Swift.Error)
    }
    
    enum State {
        case displayDashboard(accountBalance: String, totalTokenSupply: Int, tokenBalance: String)
        case fetchingValues
    }
    
    static func fetchValues(service: Web3Manager) -> AnyPublisher<Event, Never> {
        Future { promise in
            Task {
                let accountBalance = try await service.getAccountBalance()
                let tokenBalance = try await service.getTokenBalance()
                promise(Result.success(
                    .receivedValues(
                        accountBalance: accountBalance,
                        totalTokenSupply: 0,
                        tokenBalance: tokenBalance
                    )
                )
                )
            }
        }.eraseToAnyPublisher()
    }
    
    static func tokenSaleReducer(
        state: inout State,
        event: Event,
        environment: World
    ) -> AnyPublisher<Event, Never> {
        switch event {
        case .epsilon:
            state = .displayDashboard(accountBalance: "no data", totalTokenSupply: 0, tokenBalance: "no data")
            
        case .logedIn:
            state = .fetchingValues
            return fetchValues(service: environment.service)
            
        case .receivedValues(
            accountBalance: let accountBalance,
            totalTokenSupply: let totalTokenSupply,
            tokenBalance: let tokenBalance
        ):
            state = .displayDashboard(
                accountBalance: accountBalance,
                totalTokenSupply: totalTokenSupply,
                tokenBalance: tokenBalance
            )
        case .fetchingError(error: _):
            break
        }
        return Empty().eraseToAnyPublisher()
    }
    
    typealias World = Scenes.Main.World
    typealias TokenSaleStore = Store<State, Event, World>
}

