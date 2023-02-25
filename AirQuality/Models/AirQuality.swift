//
//  AirQuality.swift
//  AirQuality
//
//  Created by Andrew Acton on 2/16/23.
//

import Foundation

struct Country: Decodable {
    let data: [Data]
    
    struct Data: Decodable {
        let countryName: String
        
        enum CodingKeys: String, CodingKey {
            case countryName = "country"
        }
    }//End of struct
}//End of struct

struct State: Decodable {
    let data: [Data]
    
    struct Data: Decodable {
        let stateName: String
        
        enum CodingKeys: String, CodingKey {
            case stateName = "state"
        }
    }//End of struct
}//End of struct

struct City: Decodable {
    let data: [Data]
    
    struct Data: Decodable {
        let cityName: String
        
        enum CodingKeys: String, CodingKey {
            case cityName = "city"
        }
    }//End of struct
}//End of struct

struct CityData: Decodable {
    let data: Data
    
    struct Data: Decodable {
        let city: String
        let state: String
        let country: String
        
        let location: Location
        struct Location: Decodable {
            let coordinates: [Double]
        }//End of struct
        
        let current: Current
        struct Current: Decodable {
            let weather: Weather
            struct Weather: Decodable {
                let tp: Int
                let hu: Int
                let ws: Double
            }
            
            let pollution: Pollution
            struct Pollution: Decodable {
                let aqius: Int
            }
        }//End of struct
    }//End of struct
}//End of struct
