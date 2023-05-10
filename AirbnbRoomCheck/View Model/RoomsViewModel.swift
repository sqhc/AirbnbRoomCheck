//
//  RoomsViewModel.swift
//  AirbnbRoomCheck
//
//  Created by 沈清昊 on 5/10/23.
//

import Foundation
import Combine

class RoomsViewModel: ObservableObject{
    let location: String
    let checkin: String
    let checkout: String
    let adults: Int
    
    var roomsSearchString = "https://airbnb13.p.rapidapi.com/search-location?location="
    let headers = [
        "X-RapidAPI-Key": "54217155a0mshc59ae06a0968327p12a4c1jsn682bd9007ac0",
        "X-RapidAPI-Host": "airbnb13.p.rapidapi.com"
    ]
    
    @Published var rooms: AirbnbRooms?
    @Published var hasError = false
    @Published var error: LoadError?
    
    private var bag: Set<AnyCancellable> = []
    
    init(location: String, checkin: String, checkout: String, adults: Int){
        self.location = location
        self.checkin = checkin
        self.checkout = checkout
        self.adults = adults
    }
    
    func fetchRooms(){
        roomsSearchString += "\(location)&checkin=\(checkin)&checkout=\(checkout)&adults=\(adults)"
        
        guard let url = URL(string: roomsSearchString) else{
            hasError = true
            error = .failedToUnwrapOptional
            return
        }
        
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = headers
        
        URLSession.shared
            .dataTaskPublisher(for: request)
            .receive(on: DispatchQueue.main)
            .tryMap { result -> AirbnbRooms in
                guard let response = result.response as? HTTPURLResponse,
                      response.statusCode >= 200 && response.statusCode <= 300 else{
                          throw LoadError.invalidStatusCode
                      }
                let decoder = JSONDecoder()
                var rooms: AirbnbRooms!
                do{
                    rooms = try decoder.decode(AirbnbRooms.self, from: result.data)
                }
                catch{
                    print(error)
                    throw LoadError.custom(error: error)
                }
                return rooms
            }
            .sink { [weak self] result in
                switch result{
                case .finished:
                    break
                case .failure(let error):
                    self?.hasError = true
                    self?.error = .custom(error: error)
                }
            } receiveValue: { [weak self] rooms in
                self?.rooms = rooms
            }
            .store(in: &bag)
    }
}

extension RoomsViewModel{
    enum LoadError: LocalizedError{
        case custom(error: Error)
        case failedToDecode
        case failedToUnwrapOptional
        case invalidStatusCode
        
        var errorDescription: String?{
            switch self {
            case .custom(let error):
                return error.localizedDescription
            case .failedToDecode:
                return "Unable to decode the data."
            case .failedToUnwrapOptional:
                return "Unable to unwrap the optional value."
            case .invalidStatusCode:
                return "The request failed due to invalid status code."
            }
        }
    }
}
