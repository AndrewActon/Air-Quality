//
//  AirQualityController.swift
//  AirQuality
//
//  Created by Andrew Acton on 2/16/23.
//

import Foundation

class AirQualityController {
    
    //MARK: - String Constants
    static let baseURL = URL(string: "https://api.airvisual.com/")
    static let versionComponent = "v2"
    static let countriesComponent = "countries"
    static let statesComponent = "states"
    static let citiesComponent = "cities"
    static let cityComponent = "city"
    
    static let countryKey = "country"
    static let stateKey = "state"
    static let cityKey = "city"
    
    static let apiKeyKey = "key"
    static let apiKeyValue = "fb55f5ec-4936-421f-aa8d-e5c2a43a56aa"
    
    
    //http://api.airvisual.com/v2/countries?key={{YOUR_API_KEY}}
    static func fetchCountries(completion: @escaping (Result<[String], NetworkError>) -> Void) {
        guard let baseURL = baseURL else { return completion(.failure(.invalidURL)) }
        let versionURL = baseURL.appending(path: versionComponent)
        let countriesURL = versionURL.appending(path: countriesComponent)
        
        var components = URLComponents(url: countriesURL, resolvingAgainstBaseURL: true)
        let apiQuery = URLQueryItem(name: apiKeyKey, value: apiKeyValue)
        components?.queryItems = [apiQuery]
        
        guard let finalURL = components?.url else { return completion(.failure(.invalidURL)) }
        print(finalURL)
        
        URLSession.shared.dataTask(with: finalURL) { data, _, error in
            if let error = error {
                return completion(.failure(.thrownError(error)))
            }
            
            guard let data = data else { return completion(.failure(.noData)) }
            
            do {
                let topLevelObject = try JSONDecoder().decode(Country.self, from: data)
                let countryDicts = topLevelObject.data
                
                var listOfCountryNames: [String] = []
                
                for country in countryDicts {
                    let countryName = country.countryName
                    listOfCountryNames.append(countryName)
                }
                
                return completion(.success(listOfCountryNames))
            } catch {
                return completion(.failure(.unableToDecode))
            }
        }.resume()
    }
    
    //http://api.airvisual.com/v2/states?country={{COUNTRY_NAME}}&key={{YOUR_API_KEY}}
    static func fetchStates(forCountry: String, completion: @escaping (Result<[String], NetworkError>) -> Void) {
        guard let baseURL = baseURL else { return completion(.failure(.invalidURL)) }
        let versionURL = baseURL.appending(path: versionComponent)
        let statesURL = versionURL.appending(path: statesComponent)
        
        var components = URLComponents(url: statesURL, resolvingAgainstBaseURL: true)
        let countryQuery = URLQueryItem(name: countryKey, value: forCountry)
        let apiQuery = URLQueryItem(name: apiKeyKey, value: apiKeyValue)
        components?.queryItems = [countryQuery, apiQuery]
        
        guard let finalURL = components?.url else { return completion(.failure(.invalidURL)) }
        print(finalURL)
        
        URLSession.shared.dataTask(with: finalURL) { data, _, error in
            if let error = error {
                return completion(.failure(.thrownError(error)))
            }
            
            guard let data = data else { return completion(.failure(.noData)) }
            
            do {
                let topLevelObject = try JSONDecoder().decode(State.self, from: data)
                let stateDicts = topLevelObject.data
                
                var listOfStateNames: [String] = []
                
                for state in stateDicts {
                    let stateName = state.stateName
                    listOfStateNames.append(stateName)
                }
                
                return completion(.success(listOfStateNames))
            } catch {
                return completion(.failure(.unableToDecode))
            }
        }.resume()
    }
    
    
    //http://api.airvisual.com/v2/cities?state={{STATE_NAME}}&country={{COUNTRY_NAME}}&key={{YOUR_API_KEY}}
    static func fetchCities(forState: String, inCountry: String, completion: @escaping (Result<[String], NetworkError>) -> Void) {
        
        guard let baseURL = baseURL else { return completion(.failure(.invalidURL)) }
        print(baseURL)
        let versionURL = baseURL.appending(path: versionComponent)
        print(versionURL)
        let citiesURL = versionURL.appending(path: citiesComponent)
        print(citiesURL)
        
        var components = URLComponents(url: citiesURL, resolvingAgainstBaseURL: true)
        let stateQuery = URLQueryItem(name: stateKey, value: forState)
        let countryQuery = URLQueryItem(name: countryKey, value: inCountry)
        let apiQuery = URLQueryItem(name: apiKeyKey, value: apiKeyValue)
        components?.queryItems =  [stateQuery, countryQuery, apiQuery]
        
        guard let finalURL = components?.url else { return completion(.failure(.invalidURL)) }
        print(finalURL)
        
        URLSession.shared.dataTask(with: finalURL) { data, _, error in
            if let error = error {
                return completion(.failure(.thrownError(error)))
            }
            
            guard let data = data else { return completion(.failure(.noData)) }
            
            do {
                let topLevelObject = try JSONDecoder().decode(City.self, from: data)
                let cityDicts = topLevelObject.data
                
                var listOfCityNames: [String] = []
                
                for city in cityDicts{
                    let cityName = city.cityName
                    listOfCityNames.append(cityName)
                }
                
                return completion(.success(listOfCityNames))
                
            } catch {
                return completion(.failure(.unableToDecode))
            }
            
        }.resume()
    }
    
    
    //http://api.airvisual.com/v2/city?city=Los Angeles&state=California&country=USA&key={{YOUR_API_KEY}}
    static func fetchData(forCity: String, inState: String, inCountry: String, completion: @escaping (Result<CityData, NetworkError>) -> Void) {
        
        guard let baseURL = baseURL else {return completion(.failure(.invalidURL)) }
        let versionURL = baseURL.appending(path: versionComponent)
        let cityURL = versionURL.appending(path: cityComponent)
        
        var components = URLComponents(url: cityURL, resolvingAgainstBaseURL: true)
        let cityQuery = URLQueryItem(name: cityKey, value: forCity)
        let stateQuery = URLQueryItem(name: stateKey, value: inState)
        let countryQuery = URLQueryItem(name: countryKey, value: inCountry)
        let apiQuery = URLQueryItem(name: apiKeyKey, value: apiKeyValue)
        components?.queryItems = [cityQuery, stateQuery, countryQuery, apiQuery]
        
        guard let finalURL = components?.url else {return completion(.failure(.invalidURL)) }
        
        print(finalURL)
        
        URLSession.shared.dataTask(with: finalURL) { data, _, error in
            if let error = error {
                return completion(.failure(.thrownError(error)))
            }
            
            guard let data = data else {return completion(.failure(.noData)) }
            
            do {
                let cityData = try JSONDecoder().decode(CityData.self, from: data)
                
                return completion(.success(cityData))
            } catch {
                return completion(.failure(.unableToDecode))
            }
            
        }.resume()
        
    }
    
}//End Of Class
