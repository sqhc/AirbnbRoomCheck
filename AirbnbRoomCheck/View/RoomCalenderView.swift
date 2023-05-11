//
//  RoomCalenderView.swift
//  AirbnbRoomCheck
//
//  Created by 沈清昊 on 5/11/23.
//

import SwiftUI

struct RoomCalenderView: View {
    @StateObject var vm: RoomCalenderViewModel
    
    var body: some View {
        ZStack{
            if let months = vm.calender?.results?.calendar_months{
                List(months, id: \.year){ month in
                   CalendarItem(month: month)
                }
                .listStyle(.insetGrouped)
                .navigationTitle("Calendar of the room")
            }
            else{
                ProgressView()
            }
        }
        .onAppear(perform: vm.fetchCalender)
        .alert(isPresented: $vm.hasError, error: vm.error) {
            Button {
                
            } label: {
                Text("Cancel")
            }

        }
    }
}

struct RoomCalenderView_Previews: PreviewProvider {
    static var previews: some View {
        RoomCalenderView(vm: RoomCalenderViewModel(id: ""))
    }
}

struct CalendarItem: View{
    var month: CalenderMonth
    var body: some View{
        VStack{
            Text("\(month.name ?? ""), \(month.year ?? 0)")
            Text("Price updated at: \(month.dynamic_pricing_updated_at ?? "")")
                .frame(alignment: .leading)
            Text("Month days")
            if let days = month.days{
                List(days, id: \.date){ day in
                    Text(day.date ?? "")
                    Text(day.available ?? false ? "Available" : "Not available")
                    Text(day.available_for_checkin ?? false ? "Can checkin" : "Can't checkin")
                    Text("Local price: \(day.price?.local_price_formatted ?? "")")
                    Text("Natice price: \(day.price?.native_adjusted_price ?? 0) \(day.price?.native_currency ?? "")")
                }
                .frame(width: 300, height: 50)
            }
            Text("Conditions")
            if let conditions = month.condition_ranges{
                List(conditions, id: \.start_date){ condition in
                    Text("Start: \(condition.start_date ?? "")")
                    Text("End: \(condition.end_date ?? "")")
                    Text(condition.conditions?.closed_to_arrival ?? false ? "Close to arrival" : "Open to arrival")
                    Text(condition.conditions?.closed_to_departure ?? false ? "Close to departure" : "Open to departure")
                }
                .frame(width: 300, height: 50)
            }
        }
    }
}
