//
//  Web3.Error.swift
//  CublaxSmartContract
//
//  Created by Meona on 09.07.22.
//

import Foundation

enum Web3Error: Swift.Error {
    case undefined
    case initializeWallet(Error)
    case getAccountBalance(Error)
    case getTokenBalance(Error)
    case getTokenSupply(Error)
    case transferWeiToCubTokenSale(Error)
    case buyCubToken(Error)
}
