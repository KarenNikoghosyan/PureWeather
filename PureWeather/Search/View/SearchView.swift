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
    
    init(mainViewModel: MainViewModel) {
        self.mainViewModel = mainViewModel
        UITextField.appearance().clearButtonMode = .whileEditing
    }
    
    var body: some View {
        ZStack {
            BackgroundColor(topColor: mainViewModel.isNight ? .black : .blue, bottomColor: mainViewModel.isNight ? .gray : .white)
            
            ScrollView {
                VStack {
                    HStack {
                        SearchBar(placeholder: searchViewModel.cityString, text: $searchText, isHidden: $isHidden)
                        
                        Button {
                            if searchText != "" {
                                searchViewModel.reloadData()
                                searchViewModel.getWeatherByCityName(city: searchText)
                                withAnimation {
                                    isHidden = false
                                }
                            }
                        } label: {
                            Text(searchViewModel.search)
                                .font(.custom(searchViewModel.futuraBold, size: 18))
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.horizontal)
                    
                    Label(searchViewModel.city, systemImage: searchViewModel.locationFillImage)
                        .font(.custom(searchViewModel.futuraBold, size: 20))
                        .foregroundColor(.white)
                        .padding(.top, 20)
                        .hidden(isHidden)
                    
                    Text(searchViewModel.getCurrentTime())
                        .font(.custom(searchViewModel.futura, size: 18))
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
                            .font(.custom(searchViewModel.futura, size: 50))
                            .foregroundColor(.white)
                            .hidden(isHidden)
                    }
                    
                    Text("Feels Like \(searchViewModel.feelsLike)")
                        .font(.custom(searchViewModel.futuraBold, size: 20))
                        .foregroundColor(.white)
                        .hidden(isHidden)
                    
                    Text(searchViewModel.weatherType)
                        .font(.custom(searchViewModel.futuraBold, size: 20))
                        .foregroundColor(.white)
                        .padding(.top, 5)
                        .hidden(isHidden)
                    
                    ZStack {
                        BackgroundColor(topColor: mainViewModel.isNight ? .black : .blue, bottomColor: mainViewModel.isNight ? .gray : .white)
                            .blur(radius: 15)
                        
                        VStack {
                            Text(searchViewModel.daily)
                                .font(.custom(searchViewModel.futuraBold, size: 18))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.leading, 25)
                                .padding(.top, 10)
                            
                            ScrollView(.horizontal) {
                                LazyHStack(spacing: 30) {
                                    ForEach(searchViewModel.dailyWeather.indices, id: \.self) { index in
                                        if !searchViewModel.dailyWeather.isEmpty {
                                            let dailyWeather = searchViewModel.dailyWeather[index]
                                            DailyForecast(dayOfWeek: dailyWeather.weekday, date: dailyWeather.date, iconURL: dailyWeather.iconURL, temp: dailyWeather.temp)
                                        }
                                    }
                                }
                                .padding(.horizontal, 20.0)
                            }
                        }
                    }
                    .cornerRadius(10)
                    .frame(height: 190, alignment: .center)
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 15)
                    .hidden(isHidden)
                    Spacer()
                }
                .padding(.top, 16)
            }
            .padding(.top, 35)
            .alert("\(searchText) isn't a valid city name", isPresented: $searchViewModel.isInvalidCity) {
                Button("OK", role: .cancel) {
                    searchViewModel.isInvalidCity = false
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
            Image(systemName: "location.magnifyingglass")
                .foregroundColor(.gray)
            TextField("", text: $text)
                .foregroundColor(.gray)
                .background(
                    ZStack{
                        Color.white
                        if text.count == 0 {
                            HStack {
                                Text(placeholder)
                                    .font(.custom("Futura", size: 14))
                                    .foregroundColor(.gray)
                                Spacer()
                            }
                            .frame(maxWidth: .infinity)
                        }
                    }
                )
        }
        .padding(10)
        .background(Color(.white))
        .cornerRadius(12)
        .padding(.vertical, 10)
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(mainViewModel: MainViewModel())
    }
}
