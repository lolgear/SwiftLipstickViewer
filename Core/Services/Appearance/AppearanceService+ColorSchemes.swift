//
//  AppearanceService+ColorSchemes.swift
//  SellzForBenetton
//
//  Created by Dmitry Lobanov on 18.09.2018.
//  Copyright © 2018 Zeppelin Group. All rights reserved.
//

import Foundation
import UIKit

extension AppearanceService {
    // apply colors here.
    class ColorSchemes {
        class UpperBoundScheme {}
        
        // Bars
        class StatusBars: UpperBoundScheme {
            var content: UIStatusBarStyle?
        }
        
        class NavigationBars: UpperBoundScheme {
            var backgroundColor: UIColor?
            var tintColor: UIColor?
            var textColor: UIColor?
        }
        
        class TabBars: UpperBoundScheme {
            var tintColor: UIColor?
        }
        
        // BarItems
        class BarItems: UpperBoundScheme {
            var destructiveColor: UIColor?
        }
        
        // Views
        class BackgroundViews: UpperBoundScheme {
            var backgroundColor: UIColor?
        }
        
        // Collections
        class TableViews: UpperBoundScheme {
            var sectionTitleColor: UIColor?
            var backgroundColor: UIColor?
        }
        
        class CollectionViews: UpperBoundScheme {
            var backgroundColor: UIColor?
        }
        
        // UIControls
        class Buttons: UpperBoundScheme {
            var backgroundColor: UIColor?
            var acceptBackgroundColor: UIColor?
        }
        
        class TextFields: UpperBoundScheme {
            var tintColor: UIColor?
        }
        
        class Steppers: UpperBoundScheme {
            var tintColor: UIColor?
        }
        
        // Utilities
        class Alerts: UpperBoundScheme {
            var tintColor: UIColor?
        }
        
        /*
         more schemes
         */
        
        var schemes = [
            StatusBars(), NavigationBars(), TabBars(), BarItems(),
            BackgroundViews(), TableViews(), CollectionViews(),
            Buttons(), TextFields(), Steppers(), Alerts()] as [UpperBoundScheme & AppearanceService_ColorSchemes_Base]
        
        func scheme<T>(for search: T.Type) -> T? where T: UpperBoundScheme  {
            return self.schemes.filter { (item) in
                return type(of: item) === search
                }.first as? T
        }
                
        func apply() {
            self.schemes.forEach { $0.apply() }
        }
    }
}

extension AppearanceService.ColorSchemes.StatusBars: AppearanceService_ColorSchemes_Base {
    func apply() {
        if let content = self.content {
            UIApplication.shared.statusBarStyle = content
        }
    }
}

extension AppearanceService.ColorSchemes.NavigationBars: AppearanceService_ColorSchemes_Base {
    func apply() {
        if let color = self.backgroundColor {
            UINavigationBar.appearance().barTintColor = color
        }
        if let color = self.tintColor {
            UINavigationBar.appearance().tintColor = color
        }
        if let color = self.textColor {
            UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor : color]
        }
    }
}

extension AppearanceService.ColorSchemes.TabBars: AppearanceService_ColorSchemes_Base {
    func apply() {
        if let color = self.tintColor {
            UITabBar.appearance().tintColor = color
        }
    }
}

extension AppearanceService.ColorSchemes.BarItems: AppearanceService_ColorSchemes_Base {
    func apply() {
        if let color = self.destructiveColor {
//            DestructiveBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor : color], for: .normal)
//            DestructiveBarButtonItem.appearance(whenContainedInInstancesOf: [UINavigationBar.self]).setTitleTextAttributes([NSAttributedString.Key.foregroundColor : color], for: .normal)
//            DestructiveBarItem.appearance().setTitleTextAttributes(<#T##attributes: [NSAttributedString.Key : Any]?##[NSAttributedString.Key : Any]?#>, for: <#T##UIControl.State#>)
        }
    }
}

extension AppearanceService.ColorSchemes.BackgroundViews: AppearanceService_ColorSchemes_Base {
    func apply() {
//        ColoredBackgroundView.appearance().backgroundColor = self.backgroundColor
    }
}

extension AppearanceService.ColorSchemes.TableViews: AppearanceService_ColorSchemes_Base {
    func apply() {
//        ColoredTableView.appearance().backgroundColor = self.backgroundColor
//        ColoredRefreshControl.appearance().tintColor = UIColor.white
//        ColoredTableView.SectionHeaderAndFooterLabel.appearance().tintColor = UIColor.white
    }
}

extension AppearanceService.ColorSchemes.CollectionViews: AppearanceService_ColorSchemes_Base {
    func apply() {
//        ColoredCollectionView.appearance().backgroundColor = self.backgroundColor
    }
}


extension AppearanceService.ColorSchemes.Buttons: AppearanceService_ColorSchemes_Base {
    func apply() {
//        ColoredButton.appearance().backgroundColor = self.backgroundColor
//        AcceptColoredButton.appearance().backgroundColor = self.acceptBackgroundColor
//        AcceptColoredButton.appearance().tintColor = UIColor.white
    }
}

extension AppearanceService.ColorSchemes.TextFields: AppearanceService_ColorSchemes_Base {
    func apply() {
//        ColoredTextField.appearance().tintColor = self.tintColor
//        BaseTextField.appearance().tintColor = UIColor.white
//        UITextField.appearance().tintColor = self.tintColor
    }
}

extension AppearanceService.ColorSchemes.Steppers: AppearanceService_ColorSchemes_Base {
    func apply() {
//        ColoredStepper.appearance().tintColor = self.tintColor
    }
}

extension AppearanceService.ColorSchemes.Alerts: AppearanceService_ColorSchemes_Base {
    func apply() {
        //        if let color = self.tintColor {
        //            // TODO: Add it if needed?
        ////            SCLButton.appearance().backgroundColor = color
        //        }
    }
}
