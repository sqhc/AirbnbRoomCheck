//
//  SearchRoomsView.swift
//  AirbnbRoomCheck
//
//  Created by 沈清昊 on 5/10/23.
//

import SwiftUI

struct SearchRoomsView: View {
    @State var query = ""
    @State var adults = 1
    @State var checkinDate = Date()
    @State var checkoutDate = Date()
    
    var dateFormatter: DateFormatter{
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }
    
    var body: some View {
        VStack{
            Text("Search for rooms")
                .font(.title)
            Spacer()
            DatePicker("Checkin Date:", selection: $checkinDate, in: Date()..., displayedComponents: [.date])
            DatePicker("Checkout Date", selection: $checkoutDate, in: checkinDate..., displayedComponents: [.date])
            Stepper(value: $adults, in: 1...10) {
                Text("Number of adults: \(adults)")
            }
            TextField("Location query", text: $query)
                .background(Color.gray.opacity(0.3).cornerRadius(20))
            NavigationLink("Look for rooms") {
                RoomsView(vm: RoomsViewModel(location: query, checkin: dateFormatter.string(from: checkinDate), checkout: dateFormatter.string(from: checkoutDate), adults: adults))
            }
            Spacer()
        }
    }
}

struct SearchRoomsView_Previews: PreviewProvider {
    static var previews: some View {
        SearchRoomsView()
    }
}
