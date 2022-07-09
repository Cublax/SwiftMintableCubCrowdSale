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
    
    func getErrorMessage() -> String {
        switch self {
        case .undefined:
            return "Web3 received and Error"
        case .initializeWallet(let error):
            return "wallet init failed: \(error)"
        case .getAccountBalance(let error):
            return "Account balance error: \(error)"
        case .getTokenBalance(let error):
            return "Token Balance failed: \(error)"
        case .getTokenSupply(let error):
            return "Token supply failed: \(error)"
        case .transferWeiToCubTokenSale(let error):
            return "Transfer Wei failed: \(error)"
        case .buyCubToken(let error):
            return "Buy Cub Token failed: \(error)"
        }
    }
}
