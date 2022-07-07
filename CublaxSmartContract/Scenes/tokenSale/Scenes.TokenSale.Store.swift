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
        case intentBuyToken(amount: Int)
        
        // Effect Outputs
        case statusUpdated
        case receivedValues(accountBalance: String, totalTokenSupply: String, tokenBalance: String)
        case fetchingError(error: Swift.Error)
        case buyTokenError(error: Swift.Error)
    }
    
    enum State {
        case displayDashboard(accountBalance: String, totalTokenSupply: String, tokenBalance: String)
        case fetchingValues
    }
    
    static func fetchValues(service: Web3Manager) -> AnyPublisher<Event, Never> {
        Future { promise in
            Task {
                let accountBalance = try await service.getAccountBalance()
                let totalTokenSupply = try await service.getTokenSupply()
                let accountTokenBalance = try await service.getTokenBalance(address: service.wallet.address)
                promise(Result.success(
                    .receivedValues(
                        accountBalance: accountBalance,
                        totalTokenSupply: totalTokenSupply,
                        tokenBalance: accountTokenBalance
                    )
                )
                )
            }
        }.eraseToAnyPublisher()
    }
    
    static func buyToken(amount: Int, service: Web3Manager) -> AnyPublisher<Event, Never> {
        Future { promise in
            Task {
                let buyingStatus = try await service.buyCubToken(amount: amount)
                promise(Result.success(buyingStatus))
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
            state = .displayDashboard(
                accountBalance: "no data",
                totalTokenSupply: "no date",
                tokenBalance: "no data"
            )
            
        case .statusUpdated:
            state = .fetchingValues
            return fetchValues(service: environment.service)
            
        case .receivedValues(
            accountBalance: let accountBalance,
            totalTokenSupply: let totalTokenSupply,
            tokenBalance: let tokenBalance
        ): state = .displayDashboard(
            accountBalance: accountBalance,
            totalTokenSupply: totalTokenSupply,
            tokenBalance: tokenBalance
        )
            
        case .intentBuyToken(let amount):
            return buyToken(
                amount: amount,
                service: environment.service
            )
            
        case .fetchingError(error: _):
            break
            
        case .buyTokenError(error: _):
            break
        }
        
        return Empty().eraseToAnyPublisher()
    }
    
    typealias World = Scenes.Main.World
    typealias TokenSaleStore = Store<State, Event, World>
}

