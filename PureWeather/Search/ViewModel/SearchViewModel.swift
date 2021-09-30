//
//  SearchViewModel.swift
//  PureWeather
//
//  Created by Karen Nikoghosyan on 28/09/2021.
//

import Foundation
import Combine

class SearchViewModel: ObservableObject {
    let searchDS: WeatherSearchAPIDataSourceProtocol
    let ds: WeatherAPIDataSourceProtocol
    var subscriptions: Set<AnyCancellable> = []
    
    @Published var urlIcon: URL?
    @Published var city = ""
    @Published var currentTemp = ""
    
    init(searchDS: WeatherSearchAPIDataSourceProtocol, ds: WeatherAPIDataSourceProtocol) {
        self.searchDS = searchDS
        self.ds = ds
    }
    
    func getWeatherByCityName(city: String) {
        searchDS.searchWeather(city: city)
            .receive(on: DispatchQueue.main, options: nil)
            .sink { completion in
                switch completion {
                case .finished:break
                case .failure(let error):
                    print("Error: \(error)")
                }
            } receiveValue: {[weak self] coordinate in
                guard let self = self else {return}
                
                self.city = coordinate.name
                self.getWeatherByLatLon(lat: coordinate.coord.lat, lon: coordinate.coord.lon)
            }
            .store(in: &subscriptions)
    }
    
    func getWeatherByLatLon(lat: Double, lon: Double) {
        ds.fetchWeather(lat: lat, lon: lon)
            .receive(on: DispatchQueue.main, options: nil)
            .sink { completion in
                switch completion {
                case .finished:break
                case .failure(let error):
                    print("Error: \(error)")
                }
            } receiveValue: {[weak self] weather in
                guard let self = self else {return}
                
                guard let url = URL(string: "https://openweathermap.org/img/wn/\(weather.current.weather[0].icon)@4x.png") else {return}
                //self.getIconURL(url: "https://openweathermap.org/img/wn/\(weather.current.weather[0].icon)@4x.png")
                self.urlIcon = url
                self.currentTemp = "\(String(Int(weather.current.temp)))°"
            }
            .store(in: &subscriptions)

    }
    
    func getCurrentTime() -> String {
        let dateFormatter : DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MMM-yyyy HH:mm"
        let date = Date()
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
}
