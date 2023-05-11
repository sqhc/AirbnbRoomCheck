//
//  RoomCalenderViewModel.swift
//  AirbnbRoomCheck
//
//  Created by 沈清昊 on 5/11/23.
//

import Foundation
import Combine

class RoomCalenderViewModel: ObservableObject{
    let id: String
    
    var searchCalenderString = "https://airbnb13.p.rapidapi.com/calendar?room_id="
    let headers = [
        "X-RapidAPI-Key": "54217155a0mshc59ae06a0968327p12a4c1jsn682bd9007ac0",
        "X-RapidAPI-Host": "airbnb13.p.rapidapi.com"
    ]
    
    @Published var calender: RoomCalender?
    @Published var hasError = false
    @Published var error: LoadError?
    
    private var bag: Set<AnyCancellable> = []
    
    init(id: String){
        self.id = id
    }
    
    func fetchCalender(){
        searchCalenderString += id
        
        guard let url = URL(string: searchCalenderString) else{
            hasError = true
            error = .failedToUnwrapOptional
            return
        }
        
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = headers
        
        URLSession.shared
            .dataTaskPublisher(for: request)
            .receive(on: DispatchQueue.main)
            .tryMap { result -> RoomCalender in
                guard let response = result.response as? HTTPURLResponse,
                      response.statusCode >= 200 && response.statusCode <= 300 else{
                          throw LoadError.invalidStatusCode
                      }
                let decoder = JSONDecoder()
                var calender: RoomCalender!
                do{
                    calender = try decoder.decode(RoomCalender.self, from: result.data)
                }
                catch{
                    throw LoadError.custom(error: error)
                }
                return calender
            }
            .sink { [weak self] result in
                switch result{
                case .finished:
                    break
                case .failure(let error):
                    self?.hasError = true
                    self?.error = .custom(error: error)
                }
            } receiveValue: { [weak self] calender in
                self?.calender = calender
            }
            .store(in: &bag)
    }
}

extension RoomCalenderViewModel{
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
