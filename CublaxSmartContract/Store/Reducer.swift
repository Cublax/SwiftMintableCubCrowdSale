//
//  Reducer.swift
//  CublaxSmartContract
//
//  Created by Meona on 14.12.22.
//

import Combine

typealias Reducer<State, Action: Sendable, Environment> =
(inout State, Action, Environment) -> AnyPublisher<Action, Never>?
