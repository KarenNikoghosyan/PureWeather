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
    
    let numTabs = 2
    let minDragTranslationForSwipe: CGFloat = 50
    
    init() {
        UITabBar.appearance().backgroundColor = UIColor.white
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            WeatherView(mainViewModel: mainViewModel)
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                .tag(0)
                .highPriorityGesture(DragGesture().onEnded({ self.handleSwipe(translation: $0.translation.width )}))
            SearchView(mainViewModel: mainViewModel)
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
                .tag(1)
                .highPriorityGesture(DragGesture().onEnded({ self.handleSwipe(translation: $0.translation.width )}))
        }
        .accentColor(.red)
    }
    
    func handleSwipe(translation: CGFloat) {
        if translation > minDragTranslationForSwipe && selectedTab > 0 {
            selectedTab -= 1
        } else if translation < -minDragTranslationForSwipe && selectedTab < numTabs - 1 {
            selectedTab += 1
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

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
