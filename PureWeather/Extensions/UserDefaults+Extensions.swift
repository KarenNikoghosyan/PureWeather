//
//  UserDefaults+Extensions.swift
//  PureWeather
//
//  Created by Karen Nikoghosyan on 12/10/2021.
//

import Foundation

extension UserDefaults {
    func setIsNight(value: Bool) {
        set(value, forKey: UserDefaultsKeys.isNight.rawValue)
    }
    
    func getIsNight() -> Bool {
        return bool(forKey: UserDefaultsKeys.isNight.rawValue)
    }
}

enum UserDefaultsKeys: String {
    case isNight
}
