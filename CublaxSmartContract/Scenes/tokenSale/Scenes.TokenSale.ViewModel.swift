//
//  TokenSaleScene.ViewModel.swift
//  CublaxSmartContract
//
//  Created by Meona on 14.06.22.
//

import Foundation
import Combine
import  SwiftUI

extension Scenes.TokenSale {
    @MainActor
    final class ViewModel: ObservableObject {
        @Published var viewState = ViewState.init()
        
        let store: Scenes.TokenSale.TokenSaleStore
        private var cancellable: AnyCancellable?
        
        init(store: Scenes.TokenSale.TokenSaleStore) {
            self.store = store
            cancellable = store.$state.sink(receiveValue: { output in
                self.viewState = self.view(output)
            })
        }
        
        private func send(_ event: Event) {
            store.send(event)
        }
        
        nonisolated func intentBuyToken(amount: Int) {
            store.send(.buyToken(amount: amount))
        }
        
        nonisolated func intentDismissError(refetch: Bool = false) {
            store.send(.dismissError(refetch: refetch))
        }
        
        private func view(_ output: State) -> ViewState {
            switch output {
            case .displayDashboard(let accountBalance,
                                   let totalTokenSupply,
                                   let tokenBalance):
                return .init(accountBalance: accountBalance,
                             totalTokenSupply: totalTokenSupply,
                             tokenBalance: tokenBalance)
                
            case .fetching(let accountBalance,
                           let totalTokenSupply,
                           let tokenBalance):
                return .init(accountBalance: accountBalance,
                             totalTokenSupply: totalTokenSupply,
                             tokenBalance: tokenBalance,
                             isLoading: true)
                
            case .present(let accountBalance,
                          let totalTokenSupply,
                          let tokenBalance,
                          let error):
                return .init(accountBalance: accountBalance,
                             totalTokenSupply: totalTokenSupply,
                             tokenBalance: tokenBalance,
                             error: error)
            }
        }
    }
}
