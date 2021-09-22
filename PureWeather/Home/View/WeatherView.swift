//
//  WeatherView.swift
//  PureWeather
//
//  Created by Karen Nikoghosyan on 18/09/2021.
//

import SwiftUI
import SDWebImageSwiftUI

struct WeatherView: View {
    @ObservedObject private var weatherViewModel = WeatherViewModel(ds: WeatherAPIDataSource())
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.blue, .white]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)
            ScrollView {
                VStack(spacing: -20.0) {
                    Text(weatherViewModel.countryAndLocality)
                        .font(.largeTitle)
                        .padding(.top, 16.0)
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
                            LazyHStack {
                                ForEach(weatherViewModel.dailyWeather[0..<weatherViewModel.dailyWeather.count].indices, id: \.self) {
                                    index in
                                    DailyForecast(dayOfWeek: weatherViewModel.dailyWeather[index].weekday, iconURL: weatherViewModel.dailyWeather[index].iconURL, temp: weatherViewModel.dailyWeather[index].temp)
                                }
                            }
                        }
                        .padding(.top)
                    }
                    Spacer()
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                
            }
        }
    }
}

struct DailyForecast: View {
    var dayOfWeek: String
    var iconURL: URL
    var temp: String
    
    var body: some View {
        VStack {
            Text(dayOfWeek)
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
