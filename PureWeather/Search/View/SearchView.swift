//
//  SearchView.swift
//  PureWeather
//
//  Created by Karen Nikoghosyan on 28/09/2021.
//

import SwiftUI

struct SearchView: View {
    @ObservedObject var mainViewModel: MainViewModel
    @State private var searchText = ""
    
    init(mainViewModel: MainViewModel) {
        self.mainViewModel = mainViewModel
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.white]
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                BackgroundColor(topColor: mainViewModel.isNight ? .black : .blue, bottomColor: mainViewModel.isNight ? .gray : .white)
            }
            .navigationTitle("Search")
        }
        .searchable(text: $searchText)
        .accentColor(.white)
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(mainViewModel: MainViewModel())
    }
}
