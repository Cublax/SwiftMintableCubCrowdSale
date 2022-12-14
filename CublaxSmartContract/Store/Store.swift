//
//  Store.swift
//  CublaxSmartContract
//
//  Created by Meona on 29.06.22.
//

import Foundation
import Combine

final class Store<State, Action: Sendable, Environment>: ObservableObject {
    @Published private(set) var state: State
    
    private let environment: Environment
    private let reducer: Reducer<State, Action, Environment>
    private var cancellable: AnyCancellable!
    private let input = PassthroughSubject<Action, Never>()
    
    init(
        initialState: State,
        reducer: @escaping Reducer<State, Action, Environment>,
        environment: Environment
    ) {
        self.state = initialState
        self.reducer = reducer
        self.environment = environment
        self.cancellable = self.input
            .receive(on: DispatchQueue.main)
            .compactMap { action in
                reducer(&self.state, action, environment)
            }
            .flatMap { $0 }
            .sink { action in
                self.input.send(action)
            }
    }
    
    func send(_ action: Action) {
        input.send(action)
    }
}
