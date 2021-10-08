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
    @Published var feelsLike = ""
    @Published var weatherType = ""
    @Published var dailyWeather = [DailyWeather]()
    @Published var isInvalidCity = false
    
    init(searchDS: WeatherSearchAPIDataSourceProtocol, ds: WeatherAPIDataSourceProtocol) {
        self.searchDS = searchDS
        self.ds = ds
    }
    
    func getWeatherByCityName(city: String) {
        searchDS.searchWeather(city: city)
            .receive(on: DispatchQueue.main, options: nil)
            .sink {[weak self] completion in
                guard let self = self else {return}
                
                switch completion {
                case .finished:break
                case .failure(let error):
                    self.isInvalidCity = true
                    print("Error: \(error)")
                }
            } receiveValue: {[weak self] coordinate in
                guard let self = self else {return}
                
                self.isInvalidCity = false
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
                self.urlIcon = url
                self.currentTemp = "\(String(Int(weather.current.temp)))°"
                self.feelsLike = "\(String(Int(weather.current.feelsLike)))°"
                self.weatherType = weather.current.weather[0].main
                
                for i in 0..<weather.daily.count {
                    let weekdayAndDate = self.unixTimeToWeekday(unixTime: weather.daily[i].dt, timeZone: weather.timezone)
                    if let url = URL(string: "https://openweathermap.org/img/wn/\(weather.daily[i].weather[0].icon)@4x.png") {
                        let daily = DailyWeather(weekday: weekdayAndDate.0, date: weekdayAndDate.1, iconURL: url, temp: "\(String(Int(weather.daily[i].temp.day)))°")
                        self.dailyWeather.append(daily)
                    }
                }
            }
            .store(in: &subscriptions)
    }
    
    func unixTimeToWeekday(unixTime: Double, timeZone: String) -> (String, String) {
        let time = Date(timeIntervalSince1970: unixTime)
        var cal = Calendar(identifier: .gregorian)
        if let tz = TimeZone(identifier: timeZone) {
            cal.timeZone = tz
        }
        let weekday = (cal.component(.weekday, from: time) + 0 - 1) % 7
        let calendarWeekday = Calendar.current.weekdaySymbols[weekday]
        let date = unixTime.unixTimeToDate
        
        let shortWeekday = calendarWeekday[0..<3].uppercased()
        return (shortWeekday, date)
    }
    
    func getCurrentTime() -> String {
        let dateFormatter : DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MMM-yyyy HH:mm"
        let date = Date()
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
    
    func reloadData() {
        dailyWeather.removeAll()
    }
}
