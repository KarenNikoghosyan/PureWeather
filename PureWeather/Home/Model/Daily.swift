//
//  Daily.swift
//  PureWeather
//
//  Created by Karen Nikoghosyan on 21/09/2021.
//

import Foundation

struct Daily {
    let dt: Int
    let sunrise: Int
    let sunset: Int
    let moonrise: Int
    let moonset: Int
    let moonPhase: Double
    let temp: Temp
    let feelsLike: FeelsLike
    let pressure: Int
    let humidity: Int
    let dewPoint: Double
    let windSpeed: Double
    let windDeg: Int
    let windGust: Double
    let weather: [Weather]
    let clouds: Int
    let pop: Double
    let uvi: Double
    
    enum CodingKeys: String, CodingKey {
        case dt, sunrise, sunset, moonrise, moonset
        case moonPhase = "moon_phase"
        case temp
        case feelsLike = "feels_like"
        case pressure, humidity
        case dewPoint = "dew_point"
        case windSpeed = "wind_speed"
        case windDeg = "wind_deg"
        case windGust = "wind_gust"
        case weather, clouds, pop, uvi
    }
}

extension Daily: Decodable {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        dt = try values.decode(Int.self, forKey: .dt)
        sunrise = try values.decode(Int.self, forKey: .sunrise)
        sunset = try values.decode(Int.self, forKey: .sunset)
        moonrise = try values.decode(Int.self, forKey: .moonrise)
        moonset = try values.decode(Int.self, forKey: .moonset)
        moonPhase = try values.decode(Double.self, forKey: .moonPhase)
        temp = try values.decode(Temp.self, forKey: .temp)
        feelsLike = try values.decode(FeelsLike.self, forKey: .feelsLike)
        pressure = try values.decode(Int.self, forKey: .pressure)
        humidity = try values.decode(Int.self, forKey: .humidity)
        dewPoint = try values.decode(Double.self, forKey: .dewPoint)
        windSpeed = try values.decode(Double.self, forKey: .windSpeed)
        windDeg = try values.decode(Int.self, forKey: .windDeg)
        windGust = try values.decode(Double.self, forKey: .windGust)
        weather = try values.decode([Weather].self, forKey: .weather)
        clouds = try values.decode(Int.self, forKey: .clouds)
        pop = try values.decode(Double.self, forKey: .pop)
        uvi = try values.decode(Double.self, forKey: .uvi)
    }
}
