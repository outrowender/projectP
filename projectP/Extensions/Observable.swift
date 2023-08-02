//
//  Observable.swift
//  projectP
//
//  Created by Wender on 26/07/23.
//

import Foundation

class Observable<T> {
    
    private var listeners: [((T) -> Void)] = []
    
    var value: T {
        didSet {
            broadcast(value)
        }
    }
    
    init(_ value: T) {
        self.value = value
    }
    
    private func broadcast(_ value: T) {
        for listener in listeners {
            listener(value)
        }
    }
    
    func subscribe(_ listener: @escaping(T) -> Void) {
        listener(value)
        self.listeners.append(listener)
    }
    
    func unsubscribeAll() {
        self.listeners = []
    }
}
