//
//  MainCoordinator.swift
//  SwiftLipstickViewer
//
//  Created by Dmitry Lobanov on 28.07.2019.
//  Copyright © 2019 Dmitry Lobanov. All rights reserved.
//

import Foundation
import UIKit

class MainCoordinator: BaseCoordinator {
    var viewController: Domain_Main.MainViewController?
    var dataProvider: DataProviderService?
    var media: MediaDeliveryService?
        
    override func start() {
        // so, it is ready and we can configure it properly.
        // configure other controllers.
        //
        
        let listModel = Domain_Main.Lipstick.ListViewController.Model()
        listModel.controller = { [weak self] (index) in
            return self?.wantsLipstickDetails(at: index)
        }
        
        let samplersModel = Domain_Main.Lipstick.SamplersListViewController.Model()
        samplersModel.didSelect = { [weak listModel] (index) in
            let (previous, next) = index
            listModel?.didSelect?(.init((previous ?? 0, next)), next)
        }
        
//        let list = [.red, .orange, .yellow, .green, .blue, .purple, .black].map(LipstickSamplersListViewController.Model.Row.init)
//        samplersModel.list = list
        
//        samplersModel.list = self.dataProvider?.dataProvider?.list.compactMap{LipstickSamplersListViewController.Model.Row(color: $0.color)} ?? []
        
        let listController = Domain_Main.Lipstick.ListViewController().configured(model: listModel)
        let samplersController = Domain_Main.Lipstick.SamplersListViewController().configured(model: samplersModel)
        
        let model = Domain_Main.MainViewController.Model()
        model.topController = listController
        model.bottomController = samplersController
        self.viewController?.configured(model: model)
        
        // and...
        // go!
        self.start(model: samplersModel)
    }
    
    func updateSamplers(model: Domain_Main.Lipstick.SamplersListViewController.Model) {
        let list = self.dataProvider?.dataProvider?.list.compactMap{Domain_Main.Lipstick.SamplersListViewController.Model.Row(color: $0.color)} ?? []
        model.reset(list: list)
    }

    func start(model: Domain_Main.Lipstick.SamplersListViewController.Model) {
        self.updateSamplers(model: model)
    }

    func wantsMoreData(waitingForImages: Bool, onResult: @escaping (Result<Bool>) -> ()) {
        self.dataProvider?.dataProvider?.getProducts(options: waitingForImages ? [.shouldWaitForImages] : [], { (result) in
            // just append data, I suppose?
            onResult(result.map { !$0.isEmpty })
        })
    }
    
    func reactOnIndexNearEnd(index: Int) {
        
    }
    
    override init() {}
    init(viewController: Domain_Main.MainViewController?) {
        self.viewController = viewController
    }
}

// MARK: Configurations
extension MainCoordinator {
    func configured(dataProvider: DataProviderService?) -> Self {
        self.dataProvider = dataProvider
        return self
    }
    func configured(media: MediaDeliveryService?) -> Self {
        self.media = media
        return self
    }
}

// MARK: Controllers
extension MainCoordinator {
    func stubDetails() -> UIViewController? {
        
        let model = Domain_Main.Lipstick.DetailViewController.Model()
        
        model.title = "First"
        model.details = "Second"
        model.price = "Third"
        
        return Domain_Main.Lipstick.DetailViewController().configured(model: model)
    }
    
    func wantsLipstickDetails(at index: Int) -> UIViewController? {
//        return stubDetails()
        guard let dataProvider = self.dataProvider?.dataProvider else { return nil }
        guard dataProvider.list.count > index else { return nil }
        
        let model = dataProvider.list[index]
        // and also set media downloader for image.
        guard let details = Domain_Main.Lipstick.DetailViewController.DetailsProvider.details(model) else { return nil }
        details.media = self.media
        let controller = Domain_Main.Lipstick.DetailViewController().configured(model: details)
        return controller
    }
}
