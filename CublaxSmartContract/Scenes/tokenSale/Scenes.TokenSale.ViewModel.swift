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
        @Published var internalState: State = .init()
        private var web3: Web3Manager!
        
        let store: Store
        private var cancellable: AnyCancellable?
        
        init(store: Store) {
            self.store = store
            cancellable = $internalState.sink(receiveValue: { state in
                store.state = state
            })
        }
        
        func getweb3values() async {
            Task {
                // viewState.accountBalance = try await web3Manager.getAccountBalance()
                // viewState.tokenBalance = try await web3Manager.getTokenBalance()
            }
        }
        
        struct Effect {
            init(_ f: @escaping @Sendable () -> Void) {
                self.f = f
            }
            private let f: () -> Void
            func invoke() {
                f()
            }
        }
        
        func send(_ event: Event) {
            let effects = update(&internalState, event: event)
            self.viewState = transform(internalState: internalState)
            effects.forEach { effect in
                effect.invoke()
            }
        }
        
        private func update(_ state: inout State, event: Event) -> [Effect] {
            switch (state, event) {
            case (.start, .viewAppear):
                return []
                
            default:
                print("did not handle \(state) \(event)")
                return []
            }
        }
        
        private func transform(internalState: State) -> ViewState {
            ViewState.init(
                accountBalance: internalState.accountBalance,
                totalTokenSupply: internalState.totalTokenSupply,
                tokenBalance: internalState.tokenBalance
            )
        }
        
    }
}
