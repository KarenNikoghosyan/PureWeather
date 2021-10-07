//
//  MainView.swift
//  PureWeather
//
//  Created by Karen Nikoghosyan on 28/09/2021.
//

import SwiftUI

struct MainView: View {
    @StateObject var mainViewModel = MainViewModel()
    @State private var selectedTab = 0
    
    init() {
        UIPageControl.appearance().currentPageIndicatorTintColor = .red
        UIPageControl.appearance().pageIndicatorTintColor = UIColor.black.withAlphaComponent(0.2)
    }
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                TabView(selection: $selectedTab) {
                    WeatherView(mainViewModel: mainViewModel)
                        .tabItem {
                            Label("Home", systemImage: "house.fill")
                        }
                        .tag(0)

                    SearchView(mainViewModel: mainViewModel)
                        .tabItem {
                            Label("Search", systemImage: "magnifyingglass")
                        }
                        .tag(1)
                }
                .frame(width: geometry.size.width, height: geometry.size.height)
                .tabViewStyle(PageTabViewStyle())
                .animation(.easeInOut(duration: 0.4))
                .transition(.slide)
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct BackgroundColor: View {
    var topColor: Color
    var bottomColor: Color
    
    var body: some View {
        LinearGradient(gradient: Gradient(colors: [topColor, bottomColor]), startPoint: .topLeading, endPoint: .bottomTrailing)
            .edgesIgnoringSafeArea(.all)
            .blur(radius: 5)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
