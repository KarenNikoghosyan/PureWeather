//
//  Weather.swift
//  PureWeather
//
//  Created by Karen Nikoghosyan on 21/09/2021.
//

import Foundation

struct Weather: Decodable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}
