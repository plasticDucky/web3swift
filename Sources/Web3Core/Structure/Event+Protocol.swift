//
//  Created by Alex Vlasov.
//  Copyright © 2018 Alex Vlasov. All rights reserved.
//

import Foundation
import BigInt

// FIXME: Make me work or delete
/// Protocol for generic Ethereum event parsing results
public protocol EventParserResultProtocol {
    var eventName: String {get}
    var decodedResult: [String: Any] {get}
    var contractAddress: EthereumAddress {get}
    var transactionReceipt: TransactionReceipt? {get}
    var eventLog: EventLog? {get}
}

public struct EventParserResult: EventParserResultProtocol {
    public var eventName: String
    public var transactionReceipt: TransactionReceipt?
    public var contractAddress: EthereumAddress
    public var decodedResult: [String: Any]
    public var eventLog: EventLog?

    public init(eventName: String, transactionReceipt: TransactionReceipt? = nil, contractAddress: EthereumAddress, decodedResult: [String: Any], eventLog: EventLog? = nil) {
        self.eventName = eventName
        self.transactionReceipt = transactionReceipt
        self.contractAddress = contractAddress
        self.decodedResult = decodedResult
        self.eventLog = eventLog
    }
}

/// Protocol for generic Ethereum event parser
public protocol EventParserProtocol {
    func parseTransaction(_ transaction: CodableTransaction) async throws -> [EventParserResultProtocol]
    func parseTransactionByHash(_ hash: Data) async throws -> [EventParserResultProtocol]
    func parseBlock(_ block: Block) async throws -> [EventParserResultProtocol]
    func parseBlockByNumber(_ blockNumber: BigUInt) async throws -> [EventParserResultProtocol]
    func parseTransactionPromise(_ transaction: CodableTransaction) async throws -> [EventParserResultProtocol]
    func parseTransactionByHashPromise(_ hash: Data) async throws -> [EventParserResultProtocol]
    func parseBlockByNumberPromise(_ blockNumber: BigUInt) async throws -> [EventParserResultProtocol]
    func parseBlockPromise(_ block: Block) async throws -> [EventParserResultProtocol]
}

/// Enum for the most-used Ethereum networks. Network ID is crucial for EIP155 support
public enum Networks {
    case Sepolia
    case Mainnet
    case FNCY
    case FNCYtestnet
    case BSC
    case BSCtestnet
    case Custom(networkID: BigUInt)

    public var name: String {
        switch self {
        case .Sepolia: return "sepolia"
        case .Mainnet: return "mainnet"
        case .FNCY: return "fncy"
        case .FNCYtestnet: return "fncy_testnet"
        case .BSC: return "bsc"
        case .BSCtestnet: return "bsc_testnet"
        case .Custom: return ""
        }
    }

    public var chainID: BigUInt {
        switch self {
        case .Custom(let networkID): return networkID
        case .Mainnet: return BigUInt(1)
        case .Sepolia: return BigUInt(11155111)
        case .FNCY: return BigUInt(73)
        case .FNCYtestnet: return BigUInt(923018)
        case .BSC: return BigUInt(56)
        case .BSCtestnet: return BigUInt(97)
        }
    }

    static let allValues = [Mainnet, Sepolia, FNCY, FNCYtestnet, BSC, BSCtestnet]

    public static func fromInt(_ networkID: UInt) -> Networks {
        switch networkID {
        case 1:
            return Networks.Mainnet
        case 56:
            return Networks.BSC
        case 97:
            return Networks.BSCtestnet
        case 73:
            return Networks.FNCY
        case 923018:
            return Networks.FNCYtestnet
        case 11155111:
            return Networks.Sepolia
        default:
            return Networks.Custom(networkID: BigUInt(networkID))
        }
    }
}

extension Networks: Equatable {
    public static func ==(lhs: Networks, rhs: Networks) -> Bool {
        return lhs.chainID == rhs.chainID
            && lhs.name == rhs.name
    }
}

public protocol EventLoopRunnableProtocol {
    var name: String {get}
    func functionToRun() async
}
