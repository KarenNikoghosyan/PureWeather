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
    @StateObject var weatherViewModel = WeatherViewModel(ds: WeatherAPIDataSource())
    @ObservedObject var mainViewModel: MainViewModel
    @State private var isRefreshing = false
    
    var body: some View {
        ZStack {
            BackgroundColor(topColor: mainViewModel.isNight ? .black : .blue, bottomColor: mainViewModel.isNight ? .gray : .white)
            
            ScrollView {
                RefreshHeader(refreshing: $isRefreshing) {
                    weatherViewModel.reloadData()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        isRefreshing = false
                    }
                    
                } label: { progress in
                    if self.isRefreshing {
                        ProgressView()
                            .progressViewStyle(DarkBlueShadowProgressViewStyle())
                    } else {
                        Text(weatherViewModel.pullToRefresh)
                            .foregroundColor(.white)
                            .font(.custom(weatherViewModel.futura, size: 16))
                    }
                }

                VStack(spacing: -20.0) {
                    Text(weatherViewModel.countryAndLocality)
                        .font(.custom(weatherViewModel.futuraBold, size: 30))
                        .padding(.top, 32.0)
                    
                    WebImage(url: weatherViewModel.getCurrentWeatherIconURL())
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150, alignment: .center)
                    
                    VStack {
                        Text("\(weatherViewModel.currentTemp)")
                            .font(.custom(weatherViewModel.futuraBold, size: 72))
                            .padding(.leading, 30.0)
                        
                        Text("\(weatherViewModel.clouds)")
                            .font(.custom(weatherViewModel.futuraBold, size: 17))
                        
                        ZStack {
                            VStack(spacing: -10) {
                                Text(weatherViewModel.daily)
                                    .font(.custom(weatherViewModel.futuraBold, size: 18))
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.leading, 5)
                                    .padding(.top, 10)
                                
                                ScrollView(.horizontal) {
                                    LazyHStack(spacing: 30.0) {
                                        ForEach(weatherViewModel.dailyWeather[0..<weatherViewModel.dailyWeather.count].indices, id: \.self) {
                                            index in
                                            if !weatherViewModel.dailyWeather.isEmpty {
                                                let dailyWeather = weatherViewModel.dailyWeather[index]
                                                DailyForecast(dayOfWeek: dailyWeather.weekday, date: dailyWeather.date, iconURL: dailyWeather.iconURL, temp: dailyWeather.temp)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        .frame(height: 190, alignment: .center)
                        .frame(maxWidth: .infinity)
                        
                        ZStack {
                            VStack {
                                Text(weatherViewModel.hourly)
                                    .font(.custom(weatherViewModel.futuraBold, size: 18))
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.leading, 5)
                                    .padding(.top, 10)
                                
                                ScrollView(.horizontal) {
                                    LazyHStack(spacing: 20.0) {
                                        ForEach(weatherViewModel.hourlyWeather[0..<weatherViewModel.hourlyWeather.count].indices, id: \.self) {
                                            index in
                                            if !weatherViewModel.hourlyWeather.isEmpty {
                                                let hourlyWeather = weatherViewModel.hourlyWeather[index]
                                                HourlyForecast(time: hourlyWeather.time, date: hourlyWeather.date, iconURL: hourlyWeather.iconURL, temp: hourlyWeather.temp)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        
                        Button {
                            mainViewModel.isNight.toggle()
                            mainViewModel.save()
                        } label: {
                            Text(weatherViewModel.changeDayTime)
                                .frame(height: 50.0, alignment: .center)
                                .frame(maxWidth: .infinity)
                                .font(.custom(weatherViewModel.futuraBold, size: 16))
                        }
                        .background(.white)
                        .foregroundColor(.blue)
                        .cornerRadius(10.0)
                        .padding(.top, 25.0)
                        .padding(.horizontal, 50)
                        
                    }
                    .frame(maxWidth: .infinity)
                    Spacer()
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 20.0)
                
            }
            .enableRefresh()
            .padding(.top, 35)
        }
    }
}

struct DarkBlueShadowProgressViewStyle: ProgressViewStyle {
    func makeBody(configuration: Configuration) -> some View {
        ProgressView(configuration)
            .shadow(color: Color(red: 0, green: 0, blue: 0.6), radius: 4.0, x: 1.0, y: 2.0)
    }
}

struct DailyForecast: View {
    var dayOfWeek: String
    var date: String
    var iconURL: URL
    var temp: String
    
    var body: some View {
        VStack(spacing: 0) {
            Text(dayOfWeek)
                .font(.custom("Futura-Bold", size: 15))
                .foregroundColor(.white)
            Text(date)
                .font(.custom("Futura-Bold", size: 15))
                .foregroundColor(.white)
            WebImage(url: iconURL)
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40, alignment: .center)
            Text(temp)
                .font(.custom("Futura-Bold", size: 23))
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
        VStack(spacing: 0) {
            Text(time)
                .font(.custom("Futura-Bold", size: 15))
                .foregroundColor(.white)
            Text(date)
                .font(.custom("Futura-Bold", size: 15))
                .foregroundColor(.white)
            WebImage(url: iconURL)
                .resizable()
                .frame(width: 40, height: 40, alignment: .center)
            Text(temp)
                .font(.custom("Futura-Bold", size: 23))
                .foregroundColor(.white)
        }
    }
}

struct WeatherView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherView(mainViewModel: MainViewModel())
    }
}

//Geometry reader
//subviews
//fonts - red
