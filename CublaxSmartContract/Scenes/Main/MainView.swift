//
//  MainView.swift
//  CublaxSmartContract
//
//  Created by Meona on 23.06.22.
//

import SwiftUI
import Combine

extension Scenes { enum Main {} }

extension Scenes.Main {
    
    struct State {
        var loginState: Scenes.Login.State
        var tokenSaleState: Scenes.TokenSale.State
        
        init() {
            self.loginState = .start
            self.tokenSaleState = .placeHolder
        }
    }
    
    enum Event {
        case loginEvent(Scenes.Login.Event)
    }
    
    static var appState = State()
    static var loginStore = Scenes.Login.Store(state: appState.loginState,
                                               event: .epsilon)
    static var tokenSaleStore = Scenes.TokenSale.Store(state: appState.tokenSaleState,
                                                       event: .epsilon)
}

extension Scenes.Main {
    
    struct ContentView: View {
        
        let loginStore: Scenes.Login.Store
        let tokenSaleStore: Scenes.TokenSale.Store
        
        @SwiftUI.State private var isLoginPresented = true
        
        var body: some View {
            Scenes.TokenSale.ComponentView(store: tokenSaleStore)
                .login(isPresented: $isLoginPresented, presenting: loginStore)
                .onReceive(loginStore.$state) { loginStoreState in
                    switch loginStoreState {
                    case .signedIn:
                        isLoginPresented = false
                    default:
                        isLoginPresented = true
                    }
                }
        }
    }
    
    struct ComponentView: View {
        var body: some View {
            Scenes.Main.ContentView(loginStore: loginStore,
                                    tokenSaleStore: tokenSaleStore)
        }
    }
}
