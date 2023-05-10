//
//  ContentView.swift
//  AirbnbRoomCheck
//
//  Created by 沈清昊 on 5/10/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView{
            ZStack{
                Color.pink
                    .edgesIgnoringSafeArea(.all)
                VStack{
                    Text("What do you want to search?")
                        .foregroundColor(.white)
                        .font(.title)
                    NavigationLink("Locations", destination: SearchLocationsView())
                        .background()
                        .cornerRadius(20)
                        .padding()
                }
            }
            .navigationTitle("Welcome using Airbnb")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
