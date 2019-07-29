//
//  Services.swift
//  SwiftTrader
//
//  Created by Lobanov Dmitry on 24.02.17.
//  Copyright © 2017 OpenSourceIO. All rights reserved.
//

import Foundation
import UIKit
//import ImagineDragon

protocol ServicesInfoProtocol {
    var health: Bool {get}
    static var name: String {get}
}

protocol ServicesSetupProtocol {
    func setup()
    func tearDown()
}

protocol ServicesOnceProtocol {
    func runAtFirstTime()
}

class BaseService: NSObject {}

extension BaseService: ServicesInfoProtocol {
    @objc var health: Bool {
        return false
    }
    static var name: String {
        return self.description()
    }
}

extension BaseService: ServicesSetupProtocol {
    @objc func setup() {}
    @objc func tearDown() {}
}

extension BaseService: ServicesOnceProtocol {
    @objc func runAtFirstTime() {}
}

extension BaseService: UIApplicationDelegate {
    
}

// MARK: Services Manager.
class ServicesManager: NSObject {
    //MARK: Shared
    //In case of AppDelegate mainThread only availabililty
    
    static let shared: ServicesManager = ServicesManager()
    var services: [BaseService] = []
    var coordinator: BaseCoordinator?
    static var manager: ServicesManager {
        return shared /*(UIApplication.shared.delegate as! AppDelegate).servicesManager*/
    }
    override init() {
        // Maybe ViewControllers and Appearance
        services = [LoggingService(), NetworkService(), MediaDeliveryService(), DataProviderService()]
    }
    func setup() {
        for service in services as [ServicesSetupProtocol] {
            service.setup()
        }
    }
    func tearDown() {
        for service in services as [ServicesSetupProtocol] {
            service.tearDown()
        }
    }
    
    func runAtFirstTime() {
        storageSettings()
//        let settings = ApplicationSettingsStorage.loaded()
//        if !settings.alreadyConfiguredAfterRunAtFirstTime {
//            for service in services as [ServicesOnceProtocol] {
//                service.runAtFirstTime()
//            }
//
//            // change developer settings to something nice.
//
//            settings.alreadyConfiguredAfterRunAtFirstTime = true
//        }
    }
    
    func interServiceSetup() {
        // MediaService downloadService IS NetworkService.
        self.service(for: MediaDeliveryService.self)?.mediaManager.downloadService = MediaDeliveryService.DownloadWrapper().configured(service: self.service(for: NetworkService.self))
        
        // DataProviderService DataProvider HAS Some services
        _ = self.service(for: DataProviderService.self)?.dataProvider?.configured(network: self.service(for: NetworkService.self), media: self.service(for: MediaDeliveryService.self))
    }
}

//MARK: Settings.
//It is the best place to change them.
//We need production settings.
extension ServicesManager {
    //HINT: the best place to change default settings to something else.
    func storageSettings() {
//        ApplicationSettingsStorage.DefaultSettings = ApplicationSettingsStorage.ProductionSettings
    }
}

//MARK: Accessors
extension ServicesManager {
    func service<T>(for search: T.Type) -> T? where T: BaseService  {
        return self.services.filter { (item) in
            return type(of: item) === search
            }.first as? T
    }
    func service(name: String) -> BaseService? {
        let service = services.filter {type(of: $0).name == name}.first
        if service == nil {
            // tell something about it?
            // for example, print?
        }
        return service
    }
}

extension ServicesManager: UIApplicationDelegate {
    func servicesUIDelegates() -> [UIApplicationDelegate] {
        return services as [UIApplicationDelegate]
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        tearDown()
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        setup()
        
        runAtFirstTime()
        interServiceSetup()
        // wrap controller into navigation.
        
        
        if let delegate = application.delegate as? AppDelegate {
            let window = UIWindow(frame: UIScreen.main.bounds)
            delegate.window = window
            delegate.window?.backgroundColor = UIColor.black
            self.coordinator = RootCoordinator(window: window).configured(dataProvider: self.service(for: DataProviderService.self)).configured(media: self.service(for: MediaDeliveryService.self))
            self.coordinator?.start()
        }
        
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        for service in servicesUIDelegates() {
            service.applicationDidBecomeActive?(application)
        }
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        for service in servicesUIDelegates() {
            service.applicationWillResignActive?(application)
        }
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        for service in servicesUIDelegates() {
            service.applicationDidEnterBackground?(application)
        }
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        for service in servicesUIDelegates() {
            service.applicationWillEnterForeground?(application)
        }
    }

    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        for service in servicesUIDelegates() {
            service.application?(application, performFetchWithCompletionHandler: completionHandler)
        }
    }
    
}
