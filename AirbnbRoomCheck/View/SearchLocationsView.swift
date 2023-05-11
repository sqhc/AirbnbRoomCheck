//
//  SearchLocationsView.swift
//  AirbnbRoomCheck
//
//  Created by 沈清昊 on 5/10/23.
//

import SwiftUI

struct SearchLocationsView: View {
    @State var query = ""
    var body: some View {
        VStack{
            Text("Search for locations")
                .font(.title)
            Spacer()
            TextField("Location query", text: $query)
                .frame(width: 400, height: 50)
                .background(Color.gray.opacity(0.3).cornerRadius(20))
                .padding(10)
            NavigationLink("Search locations") {
                LocationsView(vm: LocationsViewModel(query: query))
            }
            Spacer()
        }
    }
}

struct SearchLocationsView_Previews: PreviewProvider {
    static var previews: some View {
        SearchLocationsView()
    }
}
