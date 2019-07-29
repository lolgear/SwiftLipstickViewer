//
//  Box.swift
//  SwiftLipstickViewer
//
//  Created by Dmitry Lobanov on 27.07.2019.
//  Copyright © 2019 Dmitry Lobanov. All rights reserved.
//

import Foundation
class Box<T> {
    typealias Listening = (T) -> ()
    private var listening: Listening?
    var internalValue: T
    var value: T {
        set {
            self.internalValue = newValue
            self.listening?(newValue)
        }
        get {
            return self.internalValue
        }
    }
    
    func bind(listening: @escaping Listening) {
        self.listening = listening
        listening(self.value)
    }
    
    init(_ value: T) {
        self.internalValue = value
    }
    
    func notify() {
        self.listening?(self.value)
    }
}
