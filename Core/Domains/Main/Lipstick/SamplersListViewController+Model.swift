//
//  SamplersListViewController+Model.swift
//  SwiftLipstickViewer
//
//  Created by Dmitry Lobanov on 28.07.2019.
//  Copyright © 2019 Dmitry Lobanov. All rights reserved.
//

import Foundation
import UIKit

// MARK: Model

protocol TableViewModelProtocol__Listener {
    func didAppend(at: Int)
    func didAppend(count: Int)
    func didRemoveAll(count: Int)
    func didReset(before: Int, after: Int)
}

extension Domain_Main.Lipstick.SamplersListViewController {
    class Model {
        struct Row {
            var color: UIColor?
            var selected: Box<Bool> = Box(false)
            init(color: UIColor?) {
                self.color = color
            }
            init() {}
        }
        
        typealias PreviousAndNext = (Int?, Int)
        
        var didSelect: ((PreviousAndNext) -> ())?
        
        var list = [Row]() {
            didSet {                
                self.selectIndexPath(indexPath: IndexPath(row: self.list.count / 2, section: 0))
            }
        }
        
        func selectIndexPath(indexPath: IndexPath?) {            
            guard indexPath != self.selectedIndexPath else { return }
            
            if let previous = self.selectedIndexPath {
                let element = self.element(at: previous)
                element.selected.value = false
            }
            
            let previous = self.selectedIndexPath
            self.selectedIndexPath = indexPath
            
            if let new = self.selectedIndexPath {
                let element = self.element(at: new)
                element.selected.value = true
                self.didSelect?((previous?.row, new.row))
            }
        }
        
        
        
        var selectedIndexPath: IndexPath?
        
        var listener: TableViewModelProtocol__Listener?
    }
}

// MARK: Configurations
extension Domain_Main.Lipstick.SamplersListViewController.Model {
    func configured(listener: TableViewModelProtocol__Listener?) -> Self {
        self.listener = listener
        return self
    }
}

// MARK: TableViewModelProtocol
extension Domain_Main.Lipstick.SamplersListViewController.Model : TableViewModelProtocol {
    func numberOfSections() -> Int {
        return 1
    }
    
    func countOfElements(at: Int) -> Int {
//        return self.list.count > 5 ? Int.max : self.list.count
        return self.list.count
    }
    
    func section(at: Int) -> String {
        return ""
    }
    
    func element(at: IndexPath) -> Row {
        guard at.row < self.list.count else { return Row() }
        
        return self.list[at.row % self.list.count]
    }
    
    typealias Section = String
}

// MARK: List Manipulations
extension Domain_Main.Lipstick.SamplersListViewController.Model {
    func reset(list: [Row]) {
        let before = self.list
        self.list = list
        self.listener?.didReset(before: before.count, after: self.list.count)
    }
    
    func append(list: [Row]) {
        self.list += list
        // and also call that we have added data.
        // should insert it, hehe.
        self.listener?.didAppend(count: self.list.count)
    }
}
