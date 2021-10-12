//
//  MainViewModel.swift
//  PureWeather
//
//  Created by Karen Nikoghosyan on 29/09/2021.
//

import Foundation

class MainViewModel: ObservableObject {
    @Published var isNight = UserDefaults.standard.getIsNight()
    
    func save() {
        UserDefaults.standard.setIsNight(value: self.isNight)
    }
}
