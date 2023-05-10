//
//  RoomsDataModel.swift
//  AirbnbRoomCheck
//
//  Created by 沈清昊 on 5/10/23.
//

import Foundation

struct AirbnbRooms: Codable{
    let results: [AirbnbRoom]?
}

struct AirbnbRoom: Codable{
    let id: String?
    let name: String?
    let bathrooms: Double?
    let bedrooms: Int?
    let beds: Int?
    let images: [String]?
    let persons: Int?
    let rating: Double?
    let type: String?
    let address: String?
    let previewAmenities: [String]?
    let price: RoomPrice?
}

struct RoomPrice: Codable{
    let rate: Int?
    let currency: String?
    let total: Int?
}
