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
        case intentDismissError(oldState: ViewState)
        
        // Effect Outputs
        case statusUpdated
        case receivedValues(accountBalance: String, totalTokenSupply: String, tokenBalance: String)
        case web3Error(Web3Error)
    }
    
    enum State {
        case displayDashboard(accountBalance: String, totalTokenSupply: String, tokenBalance: String)
        case fetchingValues
        case present(Web3Error)
    }
    
    static func fetchValues(service: Web3Manager) -> AnyPublisher<Event, Never> {
        Future { promise in
            Task {
                do {
                    let accountBalance = try await service.getAccountBalance()
                    let totalTokenSupply = try await service.getTokenSupply()
                    let accountTokenBalance = try await service.getTokenBalance(address: service.wallet.address)
                    promise(Result.success(
                        .receivedValues(
                            accountBalance: accountBalance,
                            totalTokenSupply: totalTokenSupply,
                            tokenBalance: accountTokenBalance
                        )
                    ))
                } catch {
                    let error = error as? Web3Error
                    promise(Result.success(
                        .web3Error(error ?? .undefined)
                    ))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    static func buyToken(amount: Int, service: Web3Manager) -> AnyPublisher<Event, Never> {
        Future { promise in
            Task {
                let buyingStatus = await service.buyCubToken(amount: amount)
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
        ):
            state = .displayDashboard(
                accountBalance: accountBalance,
                totalTokenSupply: totalTokenSupply,
                tokenBalance: tokenBalance
            )
            
        case .intentBuyToken(let amount):
            return buyToken(
                amount: amount,
                service: environment.service
            )
            
        case .web3Error(let error):
            state = .present(error)
            
        case .intentDismissError(oldState: let oldState):
            state = .displayDashboard(
                accountBalance: oldState.accountBalance,
                totalTokenSupply: oldState.totalTokenSupply,
                tokenBalance: oldState.tokenBalance
            )
        }
        
        return Empty().eraseToAnyPublisher()
    }
    
    typealias World = Scenes.Main.World
    typealias TokenSaleStore = Store<State, Event, World>
}

