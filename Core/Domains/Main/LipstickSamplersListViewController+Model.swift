//
//  LipstickSamplersListViewController+Model.swift
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

extension LipstickSamplersListViewController {
    class Model {
        struct Row {
            var color: UIColor?
            var selected: Box<Bool> = Box(false)
            init(color: UIColor?) {
                self.color = color
            }
            init() {}
        }
        
        
        var didSelect: ((Int) -> ())?
        
        var list = [Row]() {
            didSet {                
                self.selectIndexPath(indexPath: IndexPath(row: self.list.count / 2, section: 0))
            }
        }
        
        func selectIndexPath(indexPath: IndexPath?) {
            // here we can
            print("was: {\(self.list.map{$0.selected.value})} new: IndexPath: \(indexPath)")
            guard indexPath != self.selectedIndexPath else { return }
            
            if let old = self.selectedIndexPath {
                let element = self.element(at: old)
                element.selected.value = false
            }
            
            self.selectedIndexPath = indexPath
            
            if let new = self.selectedIndexPath {
                let element = self.element(at: new)
                element.selected.value = true
                self.didSelect?(new.row)
            }
            print("now: {\(self.list.map{$0.selected.value})} set: IndexPath: \(indexPath)")
        }
        
        
        
        var selectedIndexPath: IndexPath?
        
        var listener: TableViewModelProtocol__Listener?
    }
}

// MARK: Configurations
extension LipstickSamplersListViewController.Model {
    func configured(listener: TableViewModelProtocol__Listener?) -> Self {
        self.listener = listener
        return self
    }
}

// MARK: TableViewModelProtocol
extension LipstickSamplersListViewController.Model : TableViewModelProtocol {
    func numberOfSections() -> Int {
        return 1
    }
    
    func countOfElements(at: Int) -> Int {
//        return self.list.count
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
extension LipstickSamplersListViewController.Model {
    func reset(list: [Row]) {
//        self.listener?.didRemoveAll(count: self.list.count)
        let before = self.list
        self.list = list
//        self.listener?.didAppend(count: self.list.count)
        self.listener?.didReset(before: before.count, after: self.list.count)
    }
    
    func append(list: [Row]) {
        self.list += list
        // and also call that we have added data.
        // should insert it, hehe.
        self.listener?.didAppend(count: self.list.count)
    }
}
