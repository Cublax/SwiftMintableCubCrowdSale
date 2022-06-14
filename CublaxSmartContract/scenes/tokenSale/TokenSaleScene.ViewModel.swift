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
    final class TokenSaleSceneViewModel: ObservableObject {
        
        @Published var viewState = ViewState.init()
        private var web3Manager: Web3Manager
        
        init(network: Network, password: String, privateKey: String) {
            web3Manager = Web3Manager(network: network, password: password, privateKey: privateKey)
            viewState.accountBalance = web3Manager.getAccountBalance()
            viewState.tokenBalance = web3Manager.getTokenBalance()
        }
        
    }
}
