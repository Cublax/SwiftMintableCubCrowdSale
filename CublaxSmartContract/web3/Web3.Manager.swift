//
//  web3Manager.swift
//  CublaxSmartContract
//
//  Created by Meona on 13.06.22.
//

import Foundation
import web3swift
import BigInt
import Combine

actor Web3Manager {
    var wallet: Wallet!
    var keystoreManager: KeystoreManager!
    var web3: web3!
    let cublaxToken: ERC20Token
    let cublaxTokenSaleAddress: String
    private var password: String!
    
    init() {
        cublaxTokenSaleAddress = "0x470FfCAbfAC724EB9767e2bbefAe5105F25D837b"
        cublaxToken = ERC20Token(
            name: "Cublax Token",
            address: "0x150584E4dCa8EE95B59740e3cEA807196624569D",
            decimals: "0",
            symbol: "Cub"
        )
    }
    
    func setup(password: String, privateKey: String) async throws {
        try await withCheckedThrowingContinuation { continuation in
            do {
                try initializeWallet(password: password, privateKey: privateKey)
                getKeyStoreManager(walletData: wallet.data,
                                   isWalletHD: wallet.isHD)
                initializeweb3(keystoreManager: keystoreManager)
                self.password = password
                continuation.resume(with: .success(()))
            } catch {
                let error = error as? Web3Error ?? .undefined
                continuation.resume(with: .failure(error))
            }
        }
    }
    
    private func initializeweb3(keystoreManager: KeystoreManager) {
        let web3 = web3swift.web3(provider: Web3HttpProvider(URL(string: "https://sepolia.infura.io/v3/b721b56d79b04a47aeaf08d18dbc3b2e")!)!)
        web3.addKeystoreManager(keystoreManager)
        self.web3 = web3
    }
    
    private func initializeWallet(password: String, privateKey: String) throws {
        do {
            let formattedKey = privateKey.trimmingCharacters(in: .whitespacesAndNewlines)
            let dataKey = Data.fromHex(formattedKey)!
            let name = "Account 1"
            let keystore = try EthereumKeystoreV3(privateKey: dataKey, password: password)!
            let keyData = try JSONEncoder().encode(keystore.keystoreParams)
            let address = keystore.addresses!.first!.address
            wallet = Wallet(address: address, data: keyData, name: name, isHD: false)
        } catch {
            print("wallet init failed: \(error)")
            throw Web3Error.initializeWallet(error)
        }
    }
    
    private func getKeyStoreManager(walletData: Data, isWalletHD: Bool) {
        let data = walletData
        let keystoreManager: KeystoreManager
        if isWalletHD {
            let keystore = BIP32Keystore(data)!
            keystoreManager = KeystoreManager([keystore])
        } else {
            let keystore = EthereumKeystoreV3(data)!
            keystoreManager = KeystoreManager([keystore])
        }
        self.keystoreManager =  keystoreManager
    }
    
    func getAccountBalance() async throws -> String {
        let walletAddress = EthereumAddress(wallet.address)! // Address which balance we want to know
        do {
            let balanceResult = try web3.eth.getBalance(address: walletAddress)
            let balanceString = Web3.Utils.formatToEthereumUnits(balanceResult, toUnits: .eth, decimals: 5)!
            return balanceString
        } catch {
            print("Account balance error: \(error)")
            throw Web3Error.getAccountBalance(error)
        }
    }
    
    func getTokenBalance(address: String) async throws -> String {
        let walletAddress = EthereumAddress(wallet.address)! // Your wallet address
        let exploredAddress = EthereumAddress(address)!
        let erc20ContractAddress = EthereumAddress(cublaxToken.address)!
        let contract = web3.contract(Web3.Utils.erc20ABI, at: erc20ContractAddress, abiVersion: 2)!
        var options = TransactionOptions.defaultOptions
        options.from = walletAddress
        options.gasPrice = .automatic
        options.gasLimit = .automatic
        let method = "balanceOf"
        let tx = contract.read(
            method,
            parameters: [exploredAddress] as [AnyObject],
            extraData: Data(),
            transactionOptions: options)!
        do {
            let call = try tx.call()
            let balanceBigUInt = call["0"] as! BigUInt
            return String(balanceBigUInt)
        } catch {
            print("Token Balance failed: \(error)")
            throw Web3Error.getTokenBalance(error)
        }
    }
    
    func getTokenSupply() async throws -> String {
        let exploredAddress = EthereumAddress(cublaxToken.address)! // Address which balance we want to know. Here we used same wallet address
        let erc20ContractAddress = EthereumAddress(cublaxToken.address)!
        let contract = web3.contract(Web3.Utils.erc20ABI, at: erc20ContractAddress, abiVersion: 2)!
        var options = TransactionOptions.defaultOptions
        options.from = exploredAddress
        options.gasPrice = .automatic
        options.gasLimit = .automatic
        let method = "totalSupply"
        let tx = contract.read(
            method,
            parameters: [AnyObject](),
            extraData: Data(),
            transactionOptions: options)!
        do {
            let call = try tx.call()
            let balanceBigUInt = call["0"] as! BigUInt
            return String(balanceBigUInt)
        } catch {
            print("Token supply failed: \(error)")
            throw Web3Error.getTokenSupply(error)
        }
    }
    
    func transferWeiToCubTokenSale() throws {
        let value: String = "1"
        let walletAddress = EthereumAddress(wallet.address)! // Your wallet address
        let toAddress = EthereumAddress(cublaxTokenSaleAddress)!
        let contract = web3.contract(Web3.Utils.coldWalletABI, at: toAddress, abiVersion: 2)!
        let amount = Web3.Utils.parseToBigUInt(value, units: .wei)
        var options = TransactionOptions.defaultOptions
        options.value = amount
        options.from = walletAddress
        options.gasPrice = .automatic
        options.gasLimit = .automatic
        let tx = contract.write(
            "fallback",
            parameters: [AnyObject](),
            extraData: Data(),
            transactionOptions: options)!
        do {
            let result = try tx.send(password: password)
            print(result)
        } catch {
            print("Transfer Wei failed: \(error)")
            throw Web3Error.transferWeiToCubTokenSale(error)
        }
    }
    
    func buyCubToken(amount: Int) -> Scenes.TokenSale.Event {
        let value: String = "\(amount)" // Any amount of Ether you need to send
        let walletAddress = EthereumAddress(wallet.address)! // Your wallet address
        let contractAddress = EthereumAddress(cublaxTokenSaleAddress)!
        let contractMethod = "buyTokens" // Contract method you want to write
        let contractABI = cubTokenSaleABI // Contract ABI
        let abiVersion = 2 // Contract ABI version
        let parameters = [walletAddress] as [AnyObject] // parameters used to created a new project
        let extraData: Data = Data() // Extra data for contract method
        let contract = web3.contract(contractABI, at: contractAddress, abiVersion: abiVersion)!
        let amount = Web3.Utils.parseToBigUInt(value, units: .wei)
        var options = TransactionOptions.defaultOptions
        options.value = amount
        options.from = walletAddress
        options.gasPrice = .automatic
        options.gasLimit = .automatic
        let tx = contract.write(
            contractMethod,
            parameters: parameters,
            extraData: extraData,
            transactionOptions: options)!
        do {
            let result = try tx.send(password: password)
            print(result)
            return .statusUpdated
        } catch {
            print("Buy Cub Token failed: \(error)")
            return .web3Error(.buyCubToken(error))
        }
    }
}
