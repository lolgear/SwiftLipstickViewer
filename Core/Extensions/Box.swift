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
    var value: T {
        didSet(newValue) {
            self.listening?(newValue)
        }
    }
    
    func bind(listening: @escaping Listening) {
        self.listening = listening
        listening(self.value)
    }
    
    init(_ value: T) {
        self.value = value
    }
    
    func notify() {
        self.listening?(self.value)
    }
}

// we need also observe set ( old and new value pair )
