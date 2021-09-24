//
//  DailyWeather.swift
//  PureWeather
//
//  Created by Karen Nikoghosyan on 22/09/2021.
//

import Foundation

struct DailyWeather: Equatable {
    let weekday: String
    let date: String
    let iconURL: URL
    let temp: String
}
