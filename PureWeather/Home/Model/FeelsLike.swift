//
//  FeelsLike.swift
//  PureWeather
//
//  Created by Karen Nikoghosyan on 21/09/2021.
//

import Foundation

struct FeelsLike: Decodable {
    let day: Double
    let night: Double
    let eve: Double
    let morn: Double
}
