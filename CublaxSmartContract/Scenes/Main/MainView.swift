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
        
        init() {
            self.loginState = .start
        }
    }
    
    enum Event {
        case loginEvent(Scenes.Login.Event)
    }
    
    static var appState = State()
    static var loginStore = Scenes.Login.Store(state: appState.loginState,
                                               event: .start)
}

extension Scenes.Main {
    
    struct ContentView: View {
        
        let loginStore: Scenes.Login.Store
        
        @SwiftUI.State private var isLoginPresented = true
        
        var body: some View {
            DummyView()
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
            Scenes.Main.ContentView(loginStore: loginStore)
        }
    }
}

// MARK: - Dummy View

extension Scenes.Main {
    
    private struct DummyView: View {
        @SwiftUI.State private var showingAlert = false
        
        var body: some View {
            Button("Show Alert") {
                showingAlert = true
            }
            .alert("Important message", isPresented: $showingAlert) {
                Button("OK", role: .cancel) { }
            }
        }
    }
    
}
