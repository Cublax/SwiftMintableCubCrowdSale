//
//  ERC20Token.swift
//  CublaxSmartContract
//
//  Created by Meona on 13.06.22.
//

import Foundation

class ERC20Token {
    var name: String
    var address: String
    var decimals: String
    var symbol: String
    
    init(name: String, address: String, decimals: String, symbol: String) {
        self.name = name
        self.address = address
        self.decimals = decimals
        self.symbol = symbol
    }
}
