//
//  WeatherSearchAPIDataSource.swift
//  PureWeather
//
//  Created by Karen Nikoghosyan on 30/09/2021.
//

import Foundation
import Combine

protocol WeatherSearchAPIDataSourceProtocol {
    func searchWeather(city: String) -> AnyPublisher<SearchAPIResponse, WeatherError>
}

struct WeatherSearchAPIDataSource: WeatherSearchAPIDataSourceProtocol {
    static let apiKey = "e9ec1350857a4533cbf7d872abcf0b98"

    func searchWeather(city: String) -> AnyPublisher<SearchAPIResponse, WeatherError>{
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(city)&units=metric&appid=\(WeatherSearchAPIDataSource.apiKey)") else {
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
            .decode(type: SearchAPIResponse.self, decoder: JSONDecoder())
            .mapError { WeatherError.map($0) }
            .eraseToAnyPublisher()
    }
}
