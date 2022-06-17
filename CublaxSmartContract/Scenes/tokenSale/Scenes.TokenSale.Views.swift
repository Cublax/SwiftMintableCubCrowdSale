//
//  TokenSaleScene.swift
//  CublaxSmartContract
//
//  Created by Meona on 14.06.22.
//

import SwiftUI
import Combine

extension Scenes.TokenSale {
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
                    await viewModel.getweb3values()
                }
            }
        }
    }
}


struct TokenSaleScene_Previews: PreviewProvider {
    static var previews: some View {
        Scenes.TokenSale.ContentView(
            viewModel: Scenes.TokenSale.TokenSaleSceneViewModel(
                password: "",
                privateKey: ""
            )
        )
    }
}
