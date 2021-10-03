//
//  SearchView.swift
//  PureWeather
//
//  Created by Karen Nikoghosyan on 28/09/2021.
//

import SwiftUI
import SDWebImageSwiftUI

struct SearchView: View {
    @StateObject var searchViewModel = SearchViewModel(searchDS: WeatherSearchAPIDataSource(), ds: WeatherAPIDataSource())
    @ObservedObject var mainViewModel: MainViewModel
    @State private var searchText = ""
    @State private var isHidden = true
    
    var body: some View {
        ZStack {
            BackgroundColor(topColor: mainViewModel.isNight ? .black : .blue, bottomColor: mainViewModel.isNight ? .gray : .white)
            ScrollView {
                VStack {
                    HStack {
                        SearchBar(placeholder: "City", text: $searchText, isHidden: $isHidden)
                        Button {
                            if searchText != "" {
                                searchViewModel.getWeatherByCityName(city: searchText)
                                withAnimation {
                                    isHidden = false
                                }
                            }
                        } label: {
                            Text("Search")
                                .font(.custom("Futura-Bold", size: 18))
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.horizontal)
                    Label(searchViewModel.city, systemImage: "location.fill")
                        .font(.custom("Futura-Bold", size: 20))
                        .foregroundColor(.white)
                        .padding(.top, 20)
                        .hidden(isHidden)
                    Text(searchViewModel.getCurrentTime())
                        .font(.custom("Futura", size: 18))
                        .foregroundColor(.init(UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1)))
                        .padding(.top, 5)
                        .hidden(isHidden)
                    HStack(spacing: -10) {
                        WebImage(url: searchViewModel.urlIcon)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 130, height: 130)
                            .hidden(isHidden)
                        Text(searchViewModel.currentTemp)
                            .font(.custom("Futura", size: 50))
                            .foregroundColor(.white)
                            .hidden(isHidden)
                    }
                    Text("Feels Like \(searchViewModel.feelsLike)")
                        .font(.custom("Futura-Bold", size: 20))
                        .foregroundColor(.white)
                        .hidden(isHidden)
                    Text(searchViewModel.weatherType)
                        .font(.custom("Futura-Bold", size: 20))
                        .foregroundColor(.white)
                        .padding(.top, 5)
                        .hidden(isHidden)
                    ZStack {
                        LinearGradient(colors: [.blue, .white], startPoint: .topLeading, endPoint: .bottomTrailing)
                        ScrollView(.horizontal) {
                            LazyHStack(spacing: 30) {
                                ForEach(searchViewModel.dailyWeather.indices, id: \.self) { index in
                                    let dailyWeather = searchViewModel.dailyWeather[index]
                                    DailyForecast(dayOfWeek: dailyWeather.weekday, date: dailyWeather.date, iconURL: dailyWeather.iconURL, temp: dailyWeather.temp)
                                }
                            }
                            .padding(.horizontal, 20.0)
                        }
                    }
                    .blur(radius: 20)
                    .frame(width: UIScreen.main.bounds.width - 30, height: 190, alignment: .center)
                    .cornerRadius(10)
                    .padding()
                    .hidden(isHidden)
                    Spacer()
                }
            }
        }
    }
}

struct SearchBar: View {
    var placeholder: String
    
    @Binding var text: String
    @Binding var isHidden: Bool
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass").foregroundColor(.secondary)
            TextField(placeholder, text: $text)
            if text != "" {
                Image(systemName: "xmark.circle.fill")
                    .imageScale(.medium)
                    .foregroundColor(Color(.systemGray3))
                    .padding(3)
                    .onTapGesture {
                        withAnimation {
                            self.text = ""
                            isHidden = true
                        }
                    }
            }
        }
        .padding(10)
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .padding(.vertical, 10)
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(mainViewModel: MainViewModel())
    }
}
