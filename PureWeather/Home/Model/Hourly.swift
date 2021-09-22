//
//  Hourly.swift
//  PureWeather
//
//  Created by Karen Nikoghosyan on 21/09/2021.
//

import Foundation

struct Hourly {
    let dt: Int
    let temp: Double
    let feelsLike: Double
    let pressure: Int
    let humidity: Int
    let dewPoint: Double
    let uvi: Double
    let clouds: Int
    let visibility: Int
    let windSpeed: Double
    let windDeg: Int
    let windGust: Double
    let weather: [Weather]
    let pop: Double
    
    enum CodingKeys: String, CodingKey {
        case dt, sunrise, sunset, temp
        case feelsLike = "feels_like"
        case pressure, humidity
        case dewPoint = "dew_point"
        case uvi, clouds, visibility
        case windSpeed = "wind_speed"
        case windDeg = "wind_deg"
        case windGust = "wind_gust"
        case weather
        case pop
    }
}

extension Hourly: Decodable {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        dt = try values.decode(Int.self, forKey: .dt)
        temp = try values.decode(Double.self, forKey: .temp)
        feelsLike = try values.decode(Double.self, forKey: .feelsLike)
        pressure = try values.decode(Int.self, forKey: .pressure)
        humidity = try values.decode(Int.self, forKey: .humidity)
        dewPoint = try values.decode(Double.self, forKey: .dewPoint)
        uvi = try values.decode(Double.self, forKey: .uvi)
        clouds = try values.decode(Int.self, forKey: .clouds)
        visibility = try values.decode(Int.self, forKey: .visibility)
        windSpeed = try values.decode(Double.self, forKey: .windSpeed)
        windDeg = try values.decode(Int.self, forKey: .windDeg)
        windGust = try values.decode(Double.self, forKey: .windGust)
        weather = try values.decode([Weather].self, forKey: .weather)
        pop = try values.decode(Double.self, forKey: .pop)
    }
}
