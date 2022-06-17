//
//  LoginScene.swift
//  CublaxSmartContract
//
//  Created by Meona on 08.06.22.
//

import SwiftUI
import Combine


extension Scenes.Login {
    struct ContentView: View {
        @StateObject private var viewModel = LoginSceneViewModel()
        
        var body: some View {
            NavigationView {
                Form {
                    Section {
                        Toggle("Create New Account",
                               isOn: $viewModel.viewState.creatingAccount)
                        if !viewModel.viewState.creatingAccount {
                            TextField("Private Key",
                                      text: $viewModel.viewState.privateKey)
                        }
                        SecureField("Enter password",
                                    text: $viewModel.viewState.password)
                    }
                    Section {
                        Menu(viewModel.viewState.selectedNetwork.userTitle()) {
                            Button("MainNet") {
                                viewModel.updateNetwork(network: .mainNet)
                            }
                            Button("Ropsten") {
                                viewModel.updateNetwork(network: .ropsten)
                            }
                            Button("Rinkeby") {
                                viewModel.updateNetwork(network: .rinkeby)
                            }
                        }
                    }
                    NavigationLink {
                        Scenes.TokenSale.ContentView(
                            viewModel: Scenes.TokenSale.TokenSaleSceneViewModel(
                                network: viewModel.viewState.selectedNetwork,
                                password: viewModel.viewState.password,
                                privateKey: viewModel.viewState.privateKey
                            )
                        )
                    } label: {
                        Text("Login")
                            .foregroundColor(.black)
                            .frame(minWidth: 0,
                                   maxWidth: .infinity,
                                   minHeight: 0,
                                   maxHeight: .infinity,
                                   alignment: .center)
                        
                    }
                }.navigationBarTitle("Login")
            }.navigationViewStyle(StackNavigationViewStyle())
        }
    }
}

struct LoginScene_Previews: PreviewProvider {
    static var previews: some View {
        Scenes.Login.ContentView()
    }
}
