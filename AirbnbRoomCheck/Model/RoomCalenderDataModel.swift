//
//  RoomCalenderDataModel.swift
//  AirbnbRoomCheck
//
//  Created by 沈清昊 on 5/11/23.
//

import Foundation

struct RoomCalender: Codable{
    let results: CalenderMonths?
}

struct CalenderMonths: Codable{
    let calendar_months: [CalenderMonth]?
}

struct CalenderMonth: Codable{
    let days: [CalenderDay]?
    let dynamic_pricing_updated_at: String?
    let name: String?
    let year: Int?
    let condition_ranges: [DayCondition]?
}

struct CalenderDay: Codable{
    let available: Bool?
    let date: String?
    let available_for_checkin: Bool?
    let price: DayPrice?
}

struct DayPrice: Codable{
    let native_adjusted_price: Int?
    let native_currency: String?
    let local_price_formatted: String?
}

struct DayCondition: Codable{
    let start_date: String?
    let end_date: String?
    let conditions: RoomCondition?
}

struct RoomCondition: Codable{
    let closed_to_arrival: Bool?
    let closed_to_departure: Bool?
}
