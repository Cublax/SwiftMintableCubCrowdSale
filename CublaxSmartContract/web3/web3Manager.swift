//
//  web3Manager.swift
//  CublaxSmartContract
//
//  Created by Meona on 13.06.22.
//

import Foundation
import web3swift
import BigInt

 actor Web3Manager {
    var wallet: Wallet!
    var keystoreManager: KeystoreManager!
    var web3: web3!
    var token: ERC20Token!
    let cublaxTokenSaleAddress: String
    
    init(network: Network, password: String, privateKey: String) async {
        cublaxTokenSaleAddress = "0x985F086cda11d62E3fBe9Db37a0423160DEf7a04"
        token = initizalizeToken()
        wallet = initializeWallet(password: password, privateKey: privateKey)
        keystoreManager = getKeyStoreManager(walletData: wallet.data,
                                             isWalletHD: wallet.isHD)
        web3 = initializeweb3(network: network,
                              keystoreManager: keystoreManager)
    }
    
    private func initizalizeToken() -> ERC20Token {
        return ERC20Token(
            name: "Cublax Token",
            address: "0xB55A30EA9F28D361655CA7C253D76e15C35BCAE5",
            decimals: "0",
            symbol: "Cub"
        )
    }
    
    private func initializeweb3(network: Network, keystoreManager: KeystoreManager) -> web3 {
        let web3 = web3swift.web3(provider: Web3HttpProvider(URL(string: network.endpoint())!)!)
        web3.addKeystoreManager(keystoreManager)
        return web3
    }
    
    private func initializeWallet(password: String, privateKey: String) -> Wallet? {
        let formattedKey = privateKey.trimmingCharacters(in: .whitespacesAndNewlines)
        let dataKey = Data.fromHex(formattedKey)!
        let name = "Account 1"
        do {
            let keystore = try EthereumKeystoreV3(privateKey: dataKey, password: password)!
            let keyData = try JSONEncoder().encode(keystore.keystoreParams)
            let address = keystore.addresses!.first!.address
            return Wallet(address: address, data: keyData, name: name, isHD: false)
        } catch {
            print("wallet init failed: \(error)")
            return nil
        }
    }
    
    private func getKeyStoreManager(walletData: Data, isWalletHD: Bool) -> KeystoreManager {
        let data = walletData
        let keystoreManager: KeystoreManager
        if isWalletHD {
            let keystore = BIP32Keystore(data)!
            keystoreManager = KeystoreManager([keystore])
        } else {
            let keystore = EthereumKeystoreV3(data)!
            keystoreManager = KeystoreManager([keystore])
        }
        return keystoreManager
    }
    
    func getAccountBalance() async throws -> String {
        let walletAddress = EthereumAddress(wallet.address)! // Address which balance we want to know
        do {
            let balanceResult = try web3.eth.getBalance(address: walletAddress)
            let balanceString = Web3.Utils.formatToEthereumUnits(balanceResult, toUnits: .eth, decimals: 5)!
            return balanceString
        } catch {
            return "Account balance error: \(error)"
        }
    }
    
    func getTokenBalance() async throws -> String {
        let walletAddress = EthereumAddress(wallet.address)! // Your wallet address
        let exploredAddress = EthereumAddress(wallet.address)! // Address which balance we want to know. Here we used same wallet address
        let erc20ContractAddress = EthereumAddress(token.address)!
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
            return "Token Balance failed: \(error)"
        }
    }
    
    func transferWeiToTokenSale() {
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
            let password = "Ninik7474"
            let result = try tx.send(password: password)
            print(result)
        } catch {
            print("Token Balance failed: \(error)")
        }
    }
    
    func callSmartContract() {
        let value: String = "1" // Any amount of Ether you need to send
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
            let password = "Ninik7474"
            let result = try tx.send(password: password)
            print(result)
        } catch {
            print("Token Balance failed: \(error)")
        }
    }
}
