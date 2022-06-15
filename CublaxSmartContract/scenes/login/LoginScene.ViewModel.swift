//
//  LoginScene.ViewModel.swift
//  CublaxSmartContract
//
//  Created by Meona on 13.06.22.
//

import Foundation
import SwiftUI

extension LoginScene {
    struct ViewState {
        var creatingAccount = false
        var selectedNetwork: Network = .none
        var privateKey = ""
        var password = ""
        var error: Swift.Error?
    }
}

extension LoginScene {
    final class LoginSceneViewModel: ObservableObject {
        
        @Published var viewState = ViewState.init()

        func updateNetwork(network: Network) {
            self.viewState.selectedNetwork = network
        }
    }
}
