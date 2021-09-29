//
//  MainView.swift
//  PureWeather
//
//  Created by Karen Nikoghosyan on 28/09/2021.
//

import SwiftUI

struct MainView: View {
    @StateObject var mainViewModel = MainViewModel()
    
    init() {
        UITabBar.appearance().backgroundColor = UIColor.white
    }
    
    var body: some View {
        TabView {
            WeatherView(mainViewModel: mainViewModel)
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
            SearchView(mainViewModel: mainViewModel)
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
        }
        .accentColor(.red)
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

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView().environmentObject(WeatherViewModel(ds: WeatherAPIDataSource()))
    }
}
