//
//  TokenSaleScene.ViewModel.swift
//  CublaxSmartContract
//
//  Created by Meona on 14.06.22.
//

import Foundation
import Combine

extension Scenes.TokenSale {
    struct ViewState {
        var accountBalance = ""
        var totalTokenSupply = 0
        var tokenBalance = ""
    }
}

extension Scenes.TokenSale {
    @MainActor class ViewModel: ObservableObject {
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
        
        func getweb3values() async {
            Task {
                // viewState.accountBalance = try await web3Manager.getAccountBalance()
                // viewState.tokenBalance = try await web3Manager.getTokenBalance()
            }
        }
        
        func view(_ output: State) -> ViewState {
            switch output {
            case .placeHolder:
                return .init()
            case .fetchingValues:
                return .init(accountBalance: "it works", totalTokenSupply: 111, tokenBalance: "couille")
            case .valuesFetched:
                return .init()
            }
        }
    }
}
