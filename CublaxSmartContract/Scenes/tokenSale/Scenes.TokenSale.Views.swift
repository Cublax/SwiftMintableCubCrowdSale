//
//  TokenSaleScene.swift
//  CublaxSmartContract
//
//  Created by Meona on 14.06.22.
//

import SwiftUI
import Combine

extension Scenes.TokenSale {
    struct ViewState {
        var accountBalance = ""
        var totalTokenSupply = ""
        var tokenBalance = ""
        var error: Web3Error?
        var isLoading = false
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
            NavigationView{
                ContentView(
                    viewState: $viewModel.viewState,
                    intentBuyToken: viewModel.intentBuyToken,
                    intentDismissError: viewModel.intentDismissError
                )
            }
            .navigationViewStyle(.stack)
        }
    }
}

extension Scenes.TokenSale {
    struct ContentView: View {
        @Binding var viewState: ViewState
        let intentBuyToken: (_ amount: Int) -> Void
        let intentDismissError: (_ refetch: Bool) -> Void
        
        @SwiftUI.State private var tokenToBuy = 0
        
        var body: some View {
            let presentAlert = Binding<Bool>(
                get: { self.viewState.error != nil },
                set: { _ in  }
            )
            
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
                        intentBuyToken(tokenToBuy)
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
                .loading(viewState.isLoading)
                .alert(viewState.error?.getErrorMessage() ?? "",
                       isPresented: presentAlert) {
                    Button("OK", role: .cancel) {
                        intentDismissError(false)
                    }
                    Button("Refetch", role: .none) {
                        intentDismissError(true)
                    }
                }
        }
    }
}

struct TokenSaleScene_Previews: PreviewProvider {
    static var previews: some View {
        Scenes.TokenSale.ContentView(viewState: .constant(.init()),
                                     intentBuyToken: {_ in },
                                     intentDismissError: {_ in })
    }
}

