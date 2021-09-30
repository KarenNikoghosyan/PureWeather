//
//  SearchAPIResponse.swift
//  PureWeather
//
//  Created by Karen Nikoghosyan on 30/09/2021.
//

import Foundation

struct SearchAPIResponse: Decodable {
    let coord: Coordinate
    let weather: [Weather]
    let name: String
}

struct Coordinate: Decodable {
    let lon: Double
    let lat: Double
}
