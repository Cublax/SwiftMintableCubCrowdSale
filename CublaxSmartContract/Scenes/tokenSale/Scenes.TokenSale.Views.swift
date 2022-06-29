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
        
        var body: some View {
            VStack(alignment: .leading) {
                Section {
                    VStack {
                        Text("Account Balance(ETH): \(viewState.accountBalance)").bold()
                        Text("Total Token supply: \(viewState.totalTokenSupply)").bold()
                        Text("Token balance: \(viewState.tokenBalance)").bold()
                    }
                }
            }
        }
    }
}

extension Scenes.TokenSale {
    struct ComponentView: View {
        typealias ContentView = Scenes.TokenSale.ContentView
        @StateObject private var viewModel: ViewModel
        
        init(store: OldStore) {
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
        let state: Scenes.Login.ViewState = .init()
        Scenes.Login.ContentView(viewState: state,
                                 send: { _ in })
    }
}

