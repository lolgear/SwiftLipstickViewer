//
//  AppearanceService.swift
//  getZ
//
//  Created by Dmitry Lobanov on 06.09.2018.
//  Copyright © 2018 Zeppelin Group. All rights reserved.
//

import Foundation
import UIKit

protocol AppearanceService_ColorSchemes_Base {
    func apply()
}

class AppearanceService: BaseService {
    let schemes = ColorSchemes()
}

extension AppearanceService {
    func setupSchemes() {
        self.resetToDefaults()
        self.apply()
    }
    func resetToDefaults() {
        let mainColor = UIColor.white //AssetsStorage.Colors.Main.Normal
        let constructiveColor = UIColor.white //AssetsStorage.Colors.Style.Constructive
        let destructiveColor = UIColor.white //AssetsStorage.Colors.Style.Destructive
        
        self.schemes.scheme(for: ColorSchemes.StatusBars.self)?.content = .lightContent
        self.schemes.scheme(for: ColorSchemes.NavigationBars.self)?.backgroundColor = mainColor
        self.schemes.scheme(for: ColorSchemes.NavigationBars.self)?.tintColor = UIColor.white
        self.schemes.scheme(for: ColorSchemes.NavigationBars.self)?.textColor = constructiveColor
        self.schemes.scheme(for: ColorSchemes.TabBars.self)?.tintColor = constructiveColor
        
        self.schemes.scheme(for: ColorSchemes.BarItems.self)?.destructiveColor = destructiveColor

        self.schemes.scheme(for: ColorSchemes.BackgroundViews.self)?.backgroundColor = mainColor
        
        self.schemes.scheme(for: ColorSchemes.TableViews.self)?.backgroundColor = mainColor
        self.schemes.scheme(for: ColorSchemes.TableViews.self)?.sectionTitleColor = UIColor.white
        
        self.schemes.scheme(for: ColorSchemes.CollectionViews.self)?.backgroundColor = mainColor
        
        self.schemes.scheme(for: ColorSchemes.Buttons.self)?.backgroundColor = mainColor
        self.schemes.scheme(for: ColorSchemes.Buttons.self)?.acceptBackgroundColor = constructiveColor
        self.schemes.scheme(for: ColorSchemes.TextFields.self)?.tintColor = mainColor
        self.schemes.scheme(for: ColorSchemes.Steppers.self)?.tintColor = mainColor
        self.schemes.scheme(for: ColorSchemes.Alerts.self)?.tintColor = mainColor
    }
    
    func apply() {
        self.schemes.apply()
    }
}

extension AppearanceService {
    override func setup() {
        self.setupSchemes()
    }
}
