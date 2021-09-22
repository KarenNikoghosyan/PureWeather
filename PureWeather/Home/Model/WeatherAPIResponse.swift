//
//  Weather.swift
//  PureWeather
//
//  Created by Karen Nikoghosyan on 18/09/2021.
//

import Foundation

struct WeatherAPIResponse {
    let lat: Double
    let lon: Double
    let timezone: String
    let timezoneOffset: Int
    let current: Current
    let hourly: [Hourly]
    let daily: [Daily]
    
    enum CodingKeys: String, CodingKey {
        case lat, lon, timezone
        case timezoneOffset = "timezone_offset"
        case current, hourly, daily
    }
}

extension WeatherAPIResponse: Decodable {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        lat = try values.decode(Double.self, forKey: .lat)
        lon = try values.decode(Double.self, forKey: .lon)
        timezone = try values.decode(String.self, forKey: .timezone)
        timezoneOffset = try values.decode(Int.self, forKey: .timezoneOffset)
        current = try values.decode(Current.self, forKey: .current)
        hourly = try values.decode([Hourly].self, forKey: .hourly)
        daily = try values.decode([Daily].self, forKey: .daily)
    }
}
