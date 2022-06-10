//
//  GettingCurrency.swift
//  Currency Converter
//
//  Created by Kavaleuski Ivan on 31/05/2022.
//

import Foundation
import Alamofire

class GettingCurrency {
    
    static let shared = GettingCurrency()
    
    private init() {}
    
    var url = "https://api.currencyapi.com/v3/latest?apikey=oJK9Hpugr5WQEobsLVpQBmJRDEsN3rnVj1O1yJ61&currencies="
    
    func getUsers(favouriteCurrencyCode:[String], baseCurrency: String?, completion: @escaping (Result<[Currency], RequestError>) -> Void) {
        if favouriteCurrencyCode.isEmpty {
            guard URL(string: url) != nil else {
                completion(.failure(.invalidUrl))
                return
            }
        } else {
            for currency in favouriteCurrencyCode {
                url += currency
                if !(favouriteCurrencyCode.last == currency) {
                    url += "%2C"
                }
            }
        }
        if baseCurrency != nil {
            url += "&base_currency=" + (baseCurrency ?? "USD")
        }
        AF.request(url).response { response in
            switch response.result {
            case .success(let data):
                do {
                    let newCurrency = try JSONDecoder().decode(Currency.self, from: data ?? Data())
                    completion(.success([newCurrency]))
                } catch {
                    print("Error decoding users: \(error)")
                    completion(.failure(.errorDecode))
                }
            case .failure(let error):
                completion(.failure(.failedRequest))
                print(error)
            }
        }
        url = "https://api.currencyapi.com/v3/latest?apikey=oJK9Hpugr5WQEobsLVpQBmJRDEsN3rnVj1O1yJ61&currencies="
    }
    
    enum RequestError: Error {
        case invalidUrl
        case failedRequest
        case errorDecode
        case unknownError
    }
}
