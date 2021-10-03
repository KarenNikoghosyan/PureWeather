//
//  PureWeatherTests.swift
//  PureWeatherTests
//
//  Created by Karen Nikoghosyan on 22/09/2021.
//

import XCTest
import Combine
@testable import PureWeather

class PureWeatherTests: XCTestCase {
    var mockDS: WeatherAPIDataSourceProtocol!
    var sut: WeatherViewModel!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        mockDS = MockWeatherAPIDataSource()
        sut = WeatherViewModel(ds: mockDS)
    }
    
    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }
    
    func testDateFormat() {
        let value = "24/09"
        let date = 1632506400.unixTimeToDate
        XCTAssertEqual(value, date, "Wrong date format, should be dd/MM")
    }
    
    func testTimeFormat() {
        let value = "9:00 PM"
        let time = 1632506400.unixTimeToTime
        XCTAssertEqual(value, time, "Wrong time format, should be h:mm a")
    }
    
    func testDailyWeather() {
        let value = DailyWeather(weekday: "FRI", date: "24/09", iconURL: URL(string: "https://openweathermap.org/img/wn/10d@4x.png")!, temp: "25")
        let daily = sut.unixTimeToWeekday(unixTime: 1632474000, timeZone: "Asia/Jerusalem", offset: 0, url: URL(string: "https://openweathermap.org/img/wn/10d@4x.png")!, temp: "25")!
        XCTAssertEqual(value.weekday, daily.weekday, "Invalid weekday format")
        XCTAssertEqual(value.date, daily.date, "Invalid date format")
    }
}

struct MockWeatherAPIDataSource: WeatherAPIDataSourceProtocol {
    func fetchWeather(lat: Double, lon: Double) -> AnyPublisher<WeatherAPIResponse, WeatherError> {
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/onecall?lat=\(lat)&lon=\(lon)&units=metric&exclude=minutely&appid=e9ec1350857a4533cbf7d872abcf0b98")
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
