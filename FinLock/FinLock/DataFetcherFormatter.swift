//
//  DataFetcherFormatter.swift
//  FinLock
//
//  Created by Vardhan Chopada on 10/7/23.
//

import Foundation
import UIKit

class CountryService {
    func fetchCountries(completion: @escaping ([Country]?) -> Void) {
        let apiUrl = URL(string: "https://countriesnow.space/api/v0.1/countries")!
        
        URLSession.shared.dataTask(with: apiUrl) { (data, _, error) in
            if let error = error {
                print("Error fetching country data: \(error.localizedDescription)")
                self.showAlert()
                completion(nil)
                return
            }
            
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let countries = try decoder.decode(CountryResponse.self, from: data)
                    completion(countries.data)
                } catch {
                    print("Error decoding country data: \(error.localizedDescription)")
                    self.showAlert()
                    completion(nil)
                }
            }
        }.resume()
    }
    
    func fetchCitiesForCountry(_ country: String, completion: @escaping ([String]?) -> Void) {
        let apiUrl = URL(string: "https://countriesnow.space/api/v0.1/countries")!
        
        URLSession.shared.dataTask(with: apiUrl) { (data, _, error) in
            if let error = error {
                
                print("Error fetching country data: \(error.localizedDescription)")
                self.showAlert()
                completion(nil)
                return
            }
            
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let countriesResponse = try decoder.decode(CountryResponse.self, from: data)
                    
                    if let selectedCountry = countriesResponse.data.first(where: { $0.country == country }) {
                        let cities = selectedCountry.cities
                        completion(cities)
                    } else {
                        print("Selected country not found")
                        self.showAlert()
                        completion(nil)
                    }
                } catch {
                    print("Error decoding country data: \(error.localizedDescription)")
                    self.showAlert()
                    completion(nil)
                }
            }
        }.resume()
    }
    
    func showAlert() {
        let alertController = UIAlertController(title: "Error", message: "Error fetching the Content", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
        }
        alertController.addAction(okAction)
        ViewController().present(alertController, animated: true, completion: nil)
    }
}

struct Country: Codable {
    let iso2: String
    let iso3: String
    let country: String
    let cities: [String]
}

struct CountryResponse: Codable {
    let error: Bool
    let msg: String
    let data: [Country]
}
