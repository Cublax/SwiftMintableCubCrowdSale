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
}

extension Scenes.Main {
    
    struct ContentView: View {
        
        @SwiftUI.State private var isLoginPresented = true
        
        var body: some View {
            DummyView()
                .tabItem {
                    Label("Patients", systemImage: "person.3")
                }
                .login(isPresented: $isLoginPresented)
            //            .onReceive(loginStore) { loginStoreState in
            //                switch loginStoreState {
            //                case .signedIn:
            //                    isLoginPresented = false
            //                default:
            //                    isLoginPresented = true
            //                }
            //            }
                .onAppear {
                    //                loginStore.send(.epsilon)
                }
        }
        
    }
    
    struct ComponentView: View {
        var body: some View {
            Scenes.Main.ContentView()
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
