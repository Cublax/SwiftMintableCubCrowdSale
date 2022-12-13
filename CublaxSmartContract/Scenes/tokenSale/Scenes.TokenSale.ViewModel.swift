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
    struct ViewState {
        var accountBalance = ""
        var totalTokenSupply = ""
        var tokenBalance = ""
        @SwiftUI.State var displayAlert = false
        var errorMessage = ""
    }
}

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
        
        func send(_ event: Event) {
            store.send(event)
        }
        
        private func view(_ output: State) -> ViewState {
            switch output {
            case .displayDashboard(accountBalance: let accountBalance, totalTokenSupply: let totalTokenSupply, tokenBalance: let tokenBalance):
                return .init(
                    accountBalance: accountBalance,
                    totalTokenSupply: totalTokenSupply,
                    tokenBalance: tokenBalance,
                    displayAlert: false,
                    errorMessage: "")
                
            case .fetchingValues:
                return .init()
                
            case .present(let error):
                return .init(
                    accountBalance: self.viewState.accountBalance,
                    totalTokenSupply: self.viewState.totalTokenSupply,
                    tokenBalance: self.viewState.tokenBalance,
                    displayAlert: true,
                    errorMessage: error.getErrorMessage())
            }
        }
    }
}
