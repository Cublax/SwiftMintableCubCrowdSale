//
//  Network.swift
//  CublaxSmartContract
//
//  Created by Meona on 13.06.22.
//

import Foundation

public enum Network {
    case none
    case mainNet
    case ropsten
    case rinkeby
    
    func userTitle() -> String {
        switch self {
        case .none:
            return "Please select network"
        case .mainNet:
            return "Main Net"
        case .ropsten:
            return "Ropsten"
        case .rinkeby:
            return "Rinkeby"
        }
    }
    
    func endpoint() -> String {
        switch self {
        case .none:
            return ""
        case .mainNet:
            return "https://mainnet.infura.io/v3/b721b56d79b04a47aeaf08d18dbc3b2e"
        case .ropsten:
            return "https://ropsten.infura.io/v3/b721b56d79b04a47aeaf08d18dbc3b2e"
        case .rinkeby:
            return "https://rinkeby.infura.io/v3/b721b56d79b04a47aeaf08d18dbc3b2e"
        }
    }
}
