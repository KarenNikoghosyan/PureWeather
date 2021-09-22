//
//  Temp.swift
//  PureWeather
//
//  Created by Karen Nikoghosyan on 21/09/2021.
//

import Foundation

struct Temp: Decodable {
    let day: Double
    let min: Double
    let max: Double
    let night: Double
    let eve: Double
    let morn: Double
}
