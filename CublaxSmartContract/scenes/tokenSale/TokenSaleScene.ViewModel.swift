//
//  TokenSaleScene.ViewModel.swift
//  CublaxSmartContract
//
//  Created by Meona on 14.06.22.
//

import Foundation

extension TokenSaleScene {
    struct ViewState {
        var accountBalance = ""
        var totalTokenSupply = 0
        var tokenBalance = ""
    }
}

extension TokenSaleScene {
    @MainActor class TokenSaleSceneViewModel: ObservableObject {
        
        @Published var viewState = ViewState()
        private var web3Manager: Web3Manager!
        
        init(network: Network, password: String, privateKey: String) {
            Task {
                web3Manager = await Web3Manager(network: network, password: password, privateKey: privateKey)
            }
        }
        
        func getweb3values() async {
            print("VM getweb3values()")
            Task {
                viewState.accountBalance = try await web3Manager.getAccountBalance()
                viewState.tokenBalance = try await web3Manager.getTokenBalance()
                print("inside getweb3values() end of Task")
            }
        }
        
    }
}
