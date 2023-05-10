//
//  LocationsView.swift
//  AirbnbRoomCheck
//
//  Created by 沈清昊 on 5/10/23.
//

import SwiftUI

struct LocationsView: View {
    @StateObject var vm: LocationsViewModel
    
    var body: some View {
        VStack{
            if let locations = vm.locations{
                List(locations, id: \.query){ location in
                    Text("Country: \(location.country ?? "")")
                    Text("Location name: \(location.query ?? "")")
                }
                .navigationTitle("Locations")
                .listStyle(.grouped)
            }
            else{
                ProgressView()
            }
        }
        .onAppear(perform: vm.fetchLocations)
        .alert(isPresented: $vm.hasError, error: vm.error) {
            Button {
                
            } label: {
                Text("Cancel")
            }
        }
    }
}

struct LocationsView_Previews: PreviewProvider {
    static var previews: some View {
        LocationsView(vm: LocationsViewModel(query: ""))
    }
}
