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
        case buyToken(amount: Int)
        case dismissError(refetch: Bool = false)
        
        // Effect Outputs
        case statusUpdated
        case receivedValues(accountBalance: String, totalTokenSupply: String, tokenBalance: String)
        case web3Error(Web3Error)
    }
    
    enum State {
        case displayDashboard(accountBalance: String, totalTokenSupply: String, tokenBalance: String)
        case fetching(accountBalance: String, totalTokenSupply: String, tokenBalance: String)
        case present(accountBalance: String, totalTokenSupply: String, tokenBalance: String, Web3Error)
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
                do {
                    try await service.buyCubToken(amount: amount)
                    promise(Result.success(.statusUpdated))
                } catch {
                    promise(Result.success(.web3Error(.buyCubToken(error))))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    static func tokenSaleReducer(
        state: inout State,
        event: Event,
        environment: World
    ) -> AnyPublisher<Event, Never> {
        switch (state, event) {
        case (.displayDashboard(let accountBalance,
                                let totalTokenSupply,
                                let tokenBalance),
              .statusUpdated):
            state = .fetching(accountBalance: accountBalance,
                              totalTokenSupply: totalTokenSupply,
                              tokenBalance: tokenBalance)
            return fetchValues(service: environment.service)
            
        case (.fetching, .receivedValues(let accountBalance,
                                         let totalTokenSupply,
                                         let tokenBalance)):
            state = .displayDashboard(accountBalance: accountBalance,
                                      totalTokenSupply: totalTokenSupply,
                                      tokenBalance: tokenBalance)
            
        case (.fetching(let accountBalance,
                        let totalTokenSupply,
                        let tokenBalance),
              .web3Error(let error)):
            state = .present(accountBalance: accountBalance,
                             totalTokenSupply: totalTokenSupply,
                             tokenBalance: tokenBalance,
                             error)
            
        case (.present(let accountBalance,
                       let totalTokenSupply,
                       let tokenBalance, _),
              .dismissError(let refetch)):
            if refetch {
                state = .fetching(accountBalance: accountBalance,
                                  totalTokenSupply: totalTokenSupply,
                                  tokenBalance: tokenBalance)
                return fetchValues(service: environment.service)
            } else {
                state = .displayDashboard(accountBalance: "",
                                          totalTokenSupply: "",
                                          tokenBalance: "")
            }
            
        case (.displayDashboard(let accountBalance,
                                let totalTokenSupply,
                                let tokenBalance),
              .buyToken(let amount)):
            state = .fetching(accountBalance: accountBalance,
                              totalTokenSupply: totalTokenSupply,
                              tokenBalance: tokenBalance)
            return buyToken(amount: amount,
                            service: environment.service)
            
        default:
            print("*** unhandled: state: \(state), event: \(event)")
        }
        
        return Empty().eraseToAnyPublisher()
    }
    
    typealias World = Scenes.Main.World
    typealias TokenSaleStore = Store<State, Event, World>
}

