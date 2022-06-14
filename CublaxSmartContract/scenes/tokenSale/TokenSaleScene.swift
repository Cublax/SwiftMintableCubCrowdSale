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
                Section {
                    HStack {
                        Text("Account Balance(ETH):").bold()
                        Spacer()
                        Text(viewModel.viewState.accountBalance)
                    }
                    HStack {
                        Text("Total Token supply:").bold()
                        Spacer()
                        Text(viewModel.viewState.tokenBalance)
                    }
                }
            }.onAppear() {
                Task {
                    print("hello")
                    await viewModel.getweb3values()
                }
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
