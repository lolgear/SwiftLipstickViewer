//
//  ViewControllersProtocols.swift
//  SwiftMovieSearch
//
//  Created by Lobanov Dmitry on 31.03.2018.
//  Copyright © 2018 Home. All rights reserved.
//

import Foundation
protocol HasModelProtocol: class {
    associatedtype ModelType
    var model: ModelType? {set get}
    func updateForNewModel()
}

extension HasModelProtocol {
    func setup(model: ModelType) {
        self.model = model
        self.updateForNewModel()
    }
    func configured(model: ModelType) -> Self {
        self.setup(model: model)
        return self
    }
}

protocol TableViewModelProtocol {
    associatedtype Section
    associatedtype Row
    func numberOfSections() -> Int
    func countOfElements(at: Int) -> Int
    func section(at: Int) -> Section
    func element(at: IndexPath) -> Row
}

protocol CanCreateViewControllerProtocol {
    associatedtype ViewController
    func create() -> ViewController
}

protocol ViewModelCanCreateViewControllerProtocol: CanCreateViewControllerProtocol where Self.ViewController: HasModelProtocol, Self.ViewController.ModelType == Self {}

//class TheViewController: UIViewController {
//    class Model {}
//    var model: Model?
//}
//
//extension TheViewController: HasModelProtocol {
//    func updateForNewModel() {}
//}
//
//extension TheViewController.Model: ViewModelCanCreateViewControllerProtocol {
//    func create() -> TheViewController {
//        return TheViewController().configured(model: self)
//    }
//}
