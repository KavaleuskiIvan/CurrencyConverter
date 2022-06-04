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
    
    var url = "https://api.currencyapi.com/v3/latest?apikey=K2t4O0J7n7VbzIKV3ZRoMLLh1sDgyC4HLCI4Fjqa"
    //https://api.currencyapi.com/v3/latest?apikey=K2t4O0J7n7VbzIKV3ZRoMLLh1sDgyC4HLCI4Fjqa&currencies=EUR%2CUSD%2CCAD&base_currency=AED
    
    func getUsers(favouriteCurrencyCode:[String], completion: @escaping (Result<[Currency], RequestError>) -> Void) {
        if favouriteCurrencyCode.isEmpty {
            guard URL(string: url) != nil else {
                completion(.failure(.invalidUrl))
                return
            }
        } else {
            url += "&currencies="
            for currency in favouriteCurrencyCode {
                url += currency
                if !(favouriteCurrencyCode.last == currency) {
                    url += "%2C"
                }
            }
        }
        AF.request(url).response { response in
            switch response.result {
            case .success(let data):
                do {
                    let newCurrency = try JSONDecoder().decode(Currency.self, from: data ?? Data())
                    completion(.success([newCurrency]))
                } catch {
                    print("Error decoding users: \(error)")
                }
            case .failure(let error):
                print(error)
            }
        }
        url = "https://api.currencyapi.com/v3/latest?apikey=K2t4O0J7n7VbzIKV3ZRoMLLh1sDgyC4HLCI4Fjqa"
    }
    
    enum RequestError: Error {
        case invalidUrl
        case failedRequest
        case errorDecode
        case unknownError
    }
}
