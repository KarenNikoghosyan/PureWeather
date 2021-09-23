//
//  LocationManager.swift
//  PureWeather
//
//  Created by Karen Nikoghosyan on 19/09/2021.
//

import Foundation
import CoreLocation
import Combine

class WeatherViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    @Published var locationStatus: CLAuthorizationStatus?
    @Published var lastLocation: CLLocation?
    
    @Published var urlIcon = ""
    @Published var countryAndLocality = ""
    @Published var currentTemp = ""
    @Published var clouds = ""
    @Published var dailyWeather = [DailyWeather]()
    @Published var hourlyWeather = [HourlyWeather]()
    
    let ds: WeatherAPIDataSourceProtocol
    var subscriptions: Set<AnyCancellable> = []
    var currentLat = 0.0
    var currentLon = 0.0
    
    var userLatitude: String {
        return "\(lastLocation?.coordinate.latitude ?? 0)"
    }
    
    var userLongitude: String {
        return "\(lastLocation?.coordinate.longitude ?? 0)"
    }
    
    init(ds: WeatherAPIDataSourceProtocol) {
        self.ds = ds
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    var statusString: String {
        guard let status = locationStatus else {
            return "unknown"
        }
        switch status {
        case .notDetermined: return "notDetermined"
        case .authorizedWhenInUse: return "authorizedWhenInUse"
        case .authorizedAlways: return "authorizedAlways"
        case .restricted: return "restricted"
        case .denied: return "denied"
        default: return "unkown"
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        locationStatus = status
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {return}
        currentLat = location.coordinate.latitude
        currentLon = location.coordinate.longitude
        getAddressFromLatLon(latitude: currentLat, longitude: currentLon)
    }
    
    func getAddressFromLatLon(latitude: Double, longitude: Double) {
        var center: CLLocationCoordinate2D = CLLocationCoordinate2D()
        let ceo: CLGeocoder = CLGeocoder()
        center.latitude = latitude
        center.longitude = longitude
        
        let location: CLLocation = CLLocation(latitude: center.latitude, longitude: center.longitude)
        
        ceo.reverseGeocodeLocation(location) {[weak self] placemarks, error in
            guard let self = self else {return}
            if error != nil {
                print("Reverse geocoding failed: \(error!.localizedDescription)")
            }
            guard let placemark = placemarks else {return}
            if placemark.count > 0 {
                guard let placemark = placemarks?[0],
                      let country = placemark.country,
                      let locality = placemark.locality else {return}

                self.countryAndLocality = "\(country), \(locality)"
                self.getCurrentWeather(lat: latitude, lon: longitude)
            }
        }
    }
    
    func getCurrentWeather(lat: Double, lon: Double) {
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
                
                self.urlIcon = weather.current.weather[0].icon
                self.currentTemp = "\(Int(weather.current.temp))°"
                self.clouds = "\(weather.current.weather[0].main)"

                if self.dailyWeather.isEmpty {
                    for i in 0..<weather.daily.count {
                        if let url = self.getDailyHourlyWeatherIconURL(urlIcon: weather.daily[i].weather[0].icon) {
                            self.unixTimeToWeekday(unixTime: weather.daily[i].dt, timeZone: weather.timezone, offset: 0, url: url, temp: "\(String(Int(weather.daily[i].temp.day)))°")
                        }
                    }
                } else {
                    self.dailyWeather.removeAll()
                }
                
                if self.hourlyWeather.isEmpty {
                    for i in 0..<weather.hourly.count {
                        if let url = self.getDailyHourlyWeatherIconURL(urlIcon: weather.hourly[i].weather[0].icon) {
                            let hourly = HourlyWeather(time: self.unixTimeToTime(unixTime: weather.hourly[i].dt), date: self.unixTimeToDate(unixTime: weather.hourly[i].dt), iconURL: url, temp: "\(String(Int(weather.hourly[i].temp)))°")
                            self.hourlyWeather.append(hourly)
                        }
                    }
                } else {
                    self.hourlyWeather.removeAll()
                }
            }
            .store(in: &subscriptions)
    }
    
    func getCurrentWeatherIconURL() -> URL? {
        if let url = URL(string: "https://openweathermap.org/img/wn/\(urlIcon)@4x.png") {
            return url
        }
        return nil
    }
    
    func getDailyHourlyWeatherIconURL(urlIcon: String) -> URL? {
        if let url = URL(string: "https://openweathermap.org/img/wn/\(urlIcon)@4x.png") {
            return url
        }
        return nil
    }
    
    func unixTimeToWeekday(unixTime: Double, timeZone: String, offset: Int, url: URL ,temp: String) {
        if timeZone == "" || unixTime == 0.0 {
            return
        } else {
            let time = Date(timeIntervalSince1970: unixTime)
            var cal = Calendar(identifier: .gregorian)
            if let tz = TimeZone(identifier: timeZone) {
                cal.timeZone = tz
            }
            let weekday = (cal.component(.weekday, from: time) + offset - 1) % 7
            let calendarWeekday = Calendar.current.weekdaySymbols[weekday]
            let date = unixTimeToDate(unixTime: unixTime)
            
            let shortWeekday = calendarWeekday[0..<3].uppercased()
            let daily = DailyWeather(weekday: shortWeekday, date: date, iconURL: url, temp: temp)
            dailyWeather.append(daily)
        }
    }
    
    func unixTimeToDate(unixTime: Double) -> String {
        let tuple = DateFormatter().dateFormatter(unixTime: unixTime)
        let dateFormatter = tuple.0
        let date = tuple.1
        dateFormatter.dateFormat = "MM/dd"
        return dateFormatter.string(from: date)
    }
    
    func unixTimeToTime(unixTime: Double) -> String {
        let tuple = DateFormatter().dateFormatter(unixTime: unixTime)
        let dateFormatter = tuple.0
        let date = tuple.1
        dateFormatter.dateFormat = "h:mm a"
        return dateFormatter.string(from: date)
    }
    
    func reloadData() {
        dailyWeather.removeAll()
        hourlyWeather.removeAll()
        getAddressFromLatLon(latitude: currentLat, longitude: currentLon)
    }
}
