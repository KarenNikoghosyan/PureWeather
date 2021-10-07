//
//  IntroView.swift
//  PureWeather
//
//  Created by Karen Nikoghosyan on 05/10/2021.
//

import SwiftUI

struct IntroView: View {
    @State var isPresented = false
    
    var body: some View {
        ZStack {
            BackgroundColor(topColor: .blue, bottomColor: .white)
            
            VStack {
                Text("PureWeather")
                    .font(.custom("Futura-Bold", size: 35))
                    .foregroundColor(.white)
                
                Image("cloudy", bundle: .main)
                
                ProgressView()
                    .progressViewStyle(DarkBlueShadowProgressViewStyle())
                    .padding(.top, 30)
                    .scaleEffect(1.3, anchor: .center)
                    .task {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            isPresented.toggle()
                        }
                    }
                Spacer()
            }
            .padding(.top, 100)
        }
        .fullScreenCover(isPresented: $isPresented, onDismiss: nil) {
            MainView()
        }
    }
}

struct IntroView_Previews: PreviewProvider {
    static var previews: some View {
        IntroView()
    }
}
