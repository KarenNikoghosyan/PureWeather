//
//  WeatherView.swift
//  PureWeather
//
//  Created by Karen Nikoghosyan on 18/09/2021.
//

import SwiftUI
import SDWebImageSwiftUI
import Refresh

struct WeatherView: View {
    @ObservedObject private var weatherViewModel = WeatherViewModel(ds: WeatherAPIDataSource())
    @State private var isRefreshing = false
    @State private var isNight = false
    
    var body: some View {
        ZStack {
            BackgroundColor(topColor: isNight ? .black : .blue, bottomColor: isNight ? .gray : .white)
            ScrollView {
                RefreshHeader(refreshing: $isRefreshing) {
                    weatherViewModel.reloadData()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        isRefreshing = false
                    }
                } label: { progress in
                    if self.isRefreshing {
                        ProgressView()
                    } else {
                        Text("Pull to refresh")
                    }
                }

                VStack(spacing: -20.0) {
                    Text(weatherViewModel.countryAndLocality)
                        .font(.largeTitle)
                        .padding(.top, 32.0)
                    WebImage(url: weatherViewModel.getCurrentWeatherIconURL())
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150, alignment: .center)
                    VStack {
                        Text("\(weatherViewModel.currentTemp)")
                            .font(.system(size: 80))
                            .padding(.leading, 30.0)
                        Text("\(weatherViewModel.clouds)")
                            .font(.title2)
                        ScrollView(.horizontal) {
                            LazyHStack(spacing: 30.0) {
                                ForEach(weatherViewModel.dailyWeather[0..<weatherViewModel.dailyWeather.count].indices, id: \.self) {
                                    index in
                                    let dailyWeather = weatherViewModel.dailyWeather[index]
                                    DailyForecast(dayOfWeek: dailyWeather.weekday, date: dailyWeather.date, iconURL: dailyWeather.iconURL, temp: dailyWeather.temp)
                                }
                            }
                            .padding(.horizontal, 20.0)
                            .frame(maxWidth: .infinity)
                        }
                        .padding(.top, 15.0)
                        ScrollView(.horizontal) {
                            LazyHStack(spacing: 30.0) {
                                ForEach(weatherViewModel.hourlyWeather[0..<weatherViewModel.hourlyWeather.count].indices, id: \.self) {
                                    index in
                                    let hourlyWeather = weatherViewModel.hourlyWeather[index]
                                    HourlyForecast(time: hourlyWeather.time, date: hourlyWeather.date, iconURL: hourlyWeather.iconURL, temp: hourlyWeather.temp)
                                }
                            }
                            .padding(.horizontal, 20.0)
                            .frame(maxWidth: .infinity)
                        }
                        .padding(.top, 15.0)
                        Button {
                            isNight.toggle()
                        } label: {
                            Text("CHANGE DAY TIME")
                                .frame(width: UIScreen.main.bounds.width / 2 + 50.0, height: 50.0, alignment: .center)
                                .font(.custom("Futura-Bold", size: 16))
                        }
                        .background(.white)
                        .foregroundColor(.blue)
                        .cornerRadius(10.0)
                        .padding(.top, 40.0)
                    }
                    Spacer()
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                
            }
            .enableRefresh()
        }
    }
}

struct BackgroundColor: View {
    var topColor: Color
    var bottomColor: Color
    
    var body: some View {
        LinearGradient(gradient: Gradient(colors: [topColor, bottomColor]), startPoint: .topLeading, endPoint: .bottomTrailing)
            .edgesIgnoringSafeArea(.all)
    }
}

struct DailyForecast: View {
    var dayOfWeek: String
    var date: String
    var iconURL: URL
    var temp: String
    
    var body: some View {
        VStack {
            Text(dayOfWeek)
                .font(.system(size: 16, weight: .medium, design: .default))
                .foregroundColor(.white)
            Text(date)
                .font(.system(size: 16, weight: .medium, design: .default))
                .foregroundColor(.white)
            WebImage(url: iconURL)
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40, alignment: .center)
            Text(temp)
                .font(.system(size: 28, weight: .medium))
                .foregroundColor(.white)
        }
    }
}

struct HourlyForecast: View {
    var time: String
    var date: String
    var iconURL: URL
    var temp: String
    
    var body: some View {
        VStack {
            Text(time)
                .font(.system(size: 16, weight: .medium, design: .default))
                .foregroundColor(.white)
            Text(date)
                .font(.system(size: 16, weight: .medium, design: .default))
                .foregroundColor(.white)
            WebImage(url: iconURL)
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40, alignment: .center)
            Text(temp)
                .font(.system(size: 28, weight: .medium))
                .foregroundColor(.white)
        }
    }
}

struct WeatherView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherView()
    }
}
