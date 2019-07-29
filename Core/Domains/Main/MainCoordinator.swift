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
    
    var listModel: LipsticksListViewController.Model?
    
    var index = 0
    var selectedIndex: Int {
        set {
            self.index = newValue
        }
        get {
            return self.index
        }
    }
    override func start() {
        // so, it is ready and we can configure it properly.
        // configure other controllers.
        //
        
        let listModel = LipsticksListViewController.Model()
        listModel.controller = { [weak self] (index) in
            return self?.wantsLipstickDetails(at: index)
        }
        
        let samplersModel = LipstickSamplersListViewController.Model()
        samplersModel.didSelect = { [weak self, weak listModel] (index) in
            let previous = self?.selectedIndex ?? 0
            self?.selectedIndex = index
            // and also call wantsMoreData if needed?..
            listModel?.didSelect?(.init((previous, index)), index)
        }
        
//        let list = [.red, .orange, .yellow, .green, .blue, .purple, .black].map(LipstickSamplersListViewController.Model.Row.init)
//        samplersModel.list = list
        
//        samplersModel.list = self.dataProvider?.dataProvider?.list.compactMap{LipstickSamplersListViewController.Model.Row(color: $0.color)} ?? []
        
        let listController = LipsticksListViewController().configured(model: listModel)
        let samplersController = LipstickSamplersListViewController().configured(model: samplersModel)
        
        let model = Domain_Main.MainViewController.Model()
        model.topController = listController
        model.bottomController = samplersController
        self.viewController?.configured(model: model)
        
        // and...
        // go!
        self.start(model: samplersModel)
    }
    
    func updateSamplers(model: LipstickSamplersListViewController.Model) {
        let list = self.dataProvider?.dataProvider?.list.compactMap{LipstickSamplersListViewController.Model.Row(color: $0.color)} ?? []
        model.reset(list: list)
    }
    
    func selectSampler(model: LipstickSamplersListViewController.Model) {
        if let selectedIndexPath = model.selectedIndexPath {
            model.didSelect?(selectedIndexPath.row)
        }
    }
    
    func start(model: LipstickSamplersListViewController.Model) {
        self.dataProvider?.dataProvider?.getProducts({ (result) in
            self.updateSamplers(model: model)
            self.selectSampler(model: model)
        })
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
    // should be in LipstickDetailViewController.Model

    func stubDetails() -> UIViewController? {
        let model = LipstickDetailViewController.Model()
        
//        var imageURL: URL?
        model.title = "First"
        model.details = "Second"
        model.price = "Third"
        
        return LipstickDetailViewController().configured(model: model)
    }
    
    func wantsLipstickDetails(at index: Int) -> UIViewController? {
//        return stubDetails()
        guard let dataProvider = self.dataProvider?.dataProvider else { return nil }
        guard dataProvider.list.count > index else { return nil }
        
        let model = dataProvider.list[index]
        // and also set media downloader for image.
        guard let details = LipstickDetailViewController.DetailsProvider.details(model) else { return nil }
        details.media = self.media
        let controller = LipstickDetailViewController().configured(model: details)
        return controller
    }
}
