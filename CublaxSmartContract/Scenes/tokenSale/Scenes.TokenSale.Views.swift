//
//  TokenSaleScene.swift
//  CublaxSmartContract
//
//  Created by Meona on 14.06.22.
//

import SwiftUI
import Combine

extension Scenes.TokenSale {
    struct ComponentView: View {
        typealias ContentView = Scenes.TokenSale.ContentView
        @StateObject private var viewModel: ViewModel
        
        init(store: Scenes.TokenSale.TokenSaleStore) {
            _viewModel = StateObject(wrappedValue: ViewModel(store: store))
        }
        
        var body: some View {
            NavigationView{
                ContentView(
                    viewState: viewModel.viewState,
                    send: viewModel.send)
            }
            .navigationViewStyle(.stack)
        }
    }
}

extension Scenes.TokenSale {
    struct ContentView: View {
        let viewState: ViewState
        let send: (_: Event) -> Void
        
        @SwiftUI.State private var tokenToBuy = 0
        
        var body: some View {
            VStack {
                Form {
                    Section("Current") {
                        HStack {
                            Text("Account Balance(ETH):")
                                .italic()
                            
                            Text(viewState.accountBalance)
                                .bold()
                        }
                        
                        HStack {
                            Text("Total Token supply:")
                                .italic()
                            
                            Text(viewState.totalTokenSupply)
                                .bold()
                        }
                        
                        HStack {
                            Text("Token balance:")
                                .italic()
                            
                            Text(viewState.tokenBalance)
                                .bold()
                        }
                    }
                }
                
                VStack {
                    Button("Buy \(tokenToBuy) Token") {
                        send(.intentBuyToken(amount: tokenToBuy))
                        tokenToBuy = 0
                    }
                    .padding()
                    .font(.title3)
                    .background(Color.yellow)
                    .foregroundColor(.white)
                    .clipShape(Capsule())
                    
                    HStack {
                        Button("+") {
                            tokenToBuy += 1
                        }
                        .padding()
                        .frame(maxHeight: .infinity)
                        .background(.green)
                        
                        Button("-") {
                            tokenToBuy -= (tokenToBuy > 0) ? 1 : 0
                        }
                        .padding()
                        .frame(maxHeight: .infinity)
                        .background(.red)
                        
                    }.fixedSize(horizontal: false, vertical: true)
                }
                .padding(30)
            }.navigationBarTitle("Cublax Mintable Token")
            
                .alert(viewState.errorMessage, isPresented: viewState.$displayAlert) {
                    Button("OK", role: .cancel) {
                        send(.intentDismissError(oldState: viewState))
                    }
                }
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

