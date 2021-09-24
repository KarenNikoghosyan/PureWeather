//
//  WeatherAPIDataSource.swift
//  PureWeather
//
//  Created by Karen Nikoghosyan on 21/09/2021.
//

import Foundation
import Combine

protocol WeatherAPIDataSourceProtocol {
    func fetchWeather(lat: Double, lon: Double) -> AnyPublisher<WeatherAPIResponse, WeatherError>
}

struct WeatherAPIDataSource: WeatherAPIDataSourceProtocol {
    static let apiKey = "{API-KEY}"
    
    func fetchWeather(lat: Double, lon: Double) -> AnyPublisher<WeatherAPIResponse, WeatherError> {
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/onecall?lat=\(lat)&lon=\(lon)&units=metric&exclude=minutely&appid=\(WeatherAPIDataSource.apiKey)")
        else {
            return Fail(error: WeatherError.invalidURL)
                .eraseToAnyPublisher()
        }
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { response -> Data in
                guard let httpURLResponse = response.response as? HTTPURLResponse,
                      httpURLResponse.statusCode == 200 else {
                          throw WeatherError.statusCode
                      }
                return response.data
            }
            .decode(type: WeatherAPIResponse.self, decoder: JSONDecoder())
            .mapError { WeatherError.map($0) }
            .eraseToAnyPublisher()
    }
}

enum WeatherError: Error {
    case invalidURL
    case decodingError(cause: Error)
    case connectionFailed(cause: Error)
    case statusCode
    case other(error: Error)
    
    static func map(_ error: Error) -> WeatherError {
        return (error as? WeatherError) ?? other(error: error)
    }
}
