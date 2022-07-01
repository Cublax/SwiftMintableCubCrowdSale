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
    struct World {
        var service = Web3Manager()
    }
}

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
    static var world = World()
    
    static let loginReducer = Scenes.Login.loginReducer(state:event:environment:)
    static let tokenSaleReducer = Scenes.TokenSale.tokenSaleReducer(state:event:environment:)
    
    static var loginStore = Scenes.Login.LoginStore(
        initialState: .init(),
        reducer: loginReducer,
        environment: world
    )
    static let tokenSaleStore = Scenes.TokenSale.TokenSaleStore(
        initialState: .init(),
        reducer: tokenSaleReducer,
        environment: world
    )
}

extension Scenes.Main {
    
    struct ContentView: View {
        
        let loginStore: Scenes.Login.LoginStore
        let tokenSaleStore: Scenes.TokenSale.TokenSaleStore
        
        @SwiftUI.State private var isLoginPresented = true
        
        var body: some View {
            Scenes.TokenSale.ComponentView(store: tokenSaleStore)
                .login(isPresented: $isLoginPresented, presenting: loginStore)
                .onReceive(loginStore.$state) { loginStoreState in
                    switch loginStoreState {
                    case .signedIn:
                        isLoginPresented = false
                        tokenSaleStore.send(.logedIn)
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
