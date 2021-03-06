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
        let viewState: ViewState
        let send: (_: Event) -> Void
        
        @SwiftUI.State private var tokenToBuy = 0
        
        var body: some View {
            VStack(alignment: .leading) {
                Section {
                    VStack {
                        Text("Account Balance(ETH): \(viewState.accountBalance)").bold()
                        Text("Total Token supply: \(viewState.totalTokenSupply)").bold()
                        Text("Token balance: \(viewState.tokenBalance)").bold()
                        Button("Buy \(tokenToBuy) Token") {
                            send(.intentBuyToken(amount: tokenToBuy))
                        }
                        HStack {
                            Button("+") {
                                tokenToBuy += 1
                            }
                            Button("-") {
                                tokenToBuy -= (tokenToBuy > 0) ? 1 : 0
                            }
                        }
                    }
                }
            }.alert(viewState.errorMessage, isPresented: viewState.$displayAlert) {
                Button("OK", role: .cancel) {
                    send(.intentDismissError(oldState: viewState))
                }
            }
        }
    }
}

extension Scenes.TokenSale {
    struct ComponentView: View {
        typealias ContentView = Scenes.TokenSale.ContentView
        @StateObject private var viewModel: ViewModel
        
        init(store: Scenes.TokenSale.TokenSaleStore) {
            _viewModel = StateObject(wrappedValue: ViewModel(store: store))
        }
        
        var body: some View {
            ContentView(
                viewState: viewModel.viewState,
                send: viewModel.send)
        }
    }
}

struct TokenSaleScene_Previews: PreviewProvider {
    static var previews: some View {
        let state: Scenes.TokenSale.ViewState = .init()
        Scenes.TokenSale.ContentView(viewState: state,
                                     send: { _ in })
    }
}

