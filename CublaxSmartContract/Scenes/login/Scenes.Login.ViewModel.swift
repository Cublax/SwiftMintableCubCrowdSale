//
//  LoginScene.ViewModel.swift
//  CublaxSmartContract
//
//  Created by Meona on 13.06.22.
//

import Foundation
import SwiftUI

extension Scenes.Login {
    struct ViewState {
        var creatingAccount = false
        var selectedNetwork: Network = .none
        var privateKey = ""
        var password = ""
        var error: Swift.Error?
    }
}

extension Scenes.Login {
    final class LoginSceneViewModel: ObservableObject {
        
        @Published var viewState = ViewState.init()

        func updateNetwork(network: Network) {
            self.viewState.selectedNetwork = network
        }
    }
}
