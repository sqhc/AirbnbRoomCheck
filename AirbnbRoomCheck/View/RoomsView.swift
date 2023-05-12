//
//  RoomsView.swift
//  AirbnbRoomCheck
//
//  Created by 沈清昊 on 5/10/23.
//

import SwiftUI

struct RoomsView: View {
    @StateObject var vm: RoomsViewModel
    @State private var appeared = false
    
    var body: some View {
        ZStack{
            if let rooms = vm.rooms?.results{
                List(rooms, id: \.id){ room in
                    RoomItem(room: room)
                }
                .listStyle(.insetGrouped)
                .navigationTitle("Rooms in \(vm.location)")
            }
            else{
                ProgressView()
            }
        }
        .onAppear(perform: {
            guard !appeared else{ return }
            appeared.toggle()
            vm.fetchRooms()
        })
        .alert(isPresented: $vm.hasError, error: vm.error) {
            Button {
                
            } label: {
                Text("Cancel")
            }

        }
    }
}

struct RoomsView_Previews: PreviewProvider {
    static var previews: some View {
        RoomsView(vm: RoomsViewModel(location: "", checkin: "", checkout: "", adults: 1))
    }
}

struct RoomItem: View{
    var room: AirbnbRoom
    @State var showCalendar = false
    @State var showImages = false
    @State var showAmenities = false
    
    var body: some View{
        VStack{
            Text(room.name ?? "")
            Text("Address: \(room.address ?? "")")
            Text("Type: \(room.type ?? "")")
            Text("Bathrooms: \(room.bathrooms ?? 0) Bedrooms: \(room.bedrooms ?? 0) Beds: \(room.beds ?? 0) Persons: \(room.persons ?? 0)")
            HStack{
                Image(systemName: "hand.thumbsup.fill")
                Text("\(room.rating ?? 0.0)")
            }
            Button {
                showImages.toggle()
            } label: {
                Text("Images")
                    .foregroundColor(.green)
                    .font(.headline)
                    .padding(20)
                    .background(Color.white.cornerRadius(10))
            }
            .sheet(isPresented: $showImages) {
                if let images = room.images{
                    Section {
                        List(images, id: \.self){ image in
                            AsyncImage(url: URL(string: image))
                        }
                    } header: {
                        Text("Images")
                    }
                }
            }
            
            Button {
                showAmenities.toggle()
            } label: {
                Text("Amenities")
                    .foregroundColor(.white)
                    .font(.headline)
                    .padding(20)
                    .background(Color.yellow.cornerRadius(10))
            }
            .sheet(isPresented: $showAmenities) {
                if let amenities = room.previewAmenities{
                    Section {
                        List(amenities, id: \.self){ amenity in
                            Text(amenity)
                        }
                    } header: {
                        Text("Amenities")
                    }
                }
            }

            Text("Daily price: \(room.price?.rate ?? 0), total price: \(room.price?.total ?? 0) in \(room.price?.currency ?? "")")
            Button {
                showCalendar.toggle()
            } label: {
                Text("Calendar of this room")
                    .foregroundColor(.black)
                    .font(.headline)
                    .padding(20)
                    .background(Color.red.cornerRadius(10))
            }
            .sheet(isPresented: $showCalendar) {
                RoomCalenderView(vm: RoomCalenderViewModel(id: room.id ?? ""))
            }
        }
    }
}
