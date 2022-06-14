//
//  TokenSaleScene.swift
//  CublaxSmartContract
//
//  Created by Meona on 14.06.22.
//

import SwiftUI
import Combine

public enum TokenSaleScene {}

extension TokenSaleScene {
    struct ContentView: View {
        @StateObject var viewModel: TokenSaleSceneViewModel
        
        var body: some View {
            VStack(alignment: .leading) {
                TextField("", text: $viewModel.viewState.accountBalance)
                TextField("", text: $viewModel.viewState.tokenBalance)
//                TextField("", text: $viewModel.viewState.totalTokenSupply)
            }
        }
    }
}


struct TokenSaleScene_Previews: PreviewProvider {
    static var previews: some View {
        TokenSaleScene.ContentView(
            viewModel: TokenSaleScene.TokenSaleSceneViewModel(
                network: .none,
                password: "",
                privateKey: ""
            )
        )
    }
}
