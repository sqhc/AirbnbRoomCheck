//
//  LocationsViewModel.swift
//  AirbnbRoomCheck
//
//  Created by 沈清昊 on 5/10/23.
//

import Foundation
import Combine

class LocationsViewModel: ObservableObject{
    let query: String
    
    var searchLocationsString = "https://airbnb13.p.rapidapi.com/autocomplete?query="
    let headers = [
        "X-RapidAPI-Key": "54217155a0mshc59ae06a0968327p12a4c1jsn682bd9007ac0",
        "X-RapidAPI-Host": "airbnb13.p.rapidapi.com"
    ]
    
    @Published var locations: [AirbnbLocation]?
    @Published var hasError = false
    @Published var error: LoadError?
    
    private var bag: Set<AnyCancellable> = []
    
    init(query: String){
        self.query = query
    }
    
    func fetchLocations(){
        searchLocationsString += query
        
        guard let url = URL(string: searchLocationsString) else{
            hasError = true
            error = .failedToUnwrapOptional
            return
        }
        
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = headers
        
        URLSession.shared
            .dataTaskPublisher(for: request)
            .receive(on: DispatchQueue.main)
            .tryMap { result -> [AirbnbLocation] in
                guard let response = result.response as? HTTPURLResponse,
                      response.statusCode >= 200 && response.statusCode <= 300 else{
                          throw LoadError.invalidStatusCode
                      }
                let deocoder = JSONDecoder()
                guard let locations = try? deocoder.decode([AirbnbLocation].self, from: result.data) else{
                    throw LoadError.failedToDecode
                }
                return locations
            }
            .sink { [weak self] result in
                switch result{
                case .finished:
                    break
                case .failure(let error):
                    self?.hasError = true
                    self?.error = .custom(error: error)
                }
            } receiveValue: { [weak self] locations in
                self?.locations = locations
            }
            .store(in: &bag)
    }
}

extension LocationsViewModel{
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
