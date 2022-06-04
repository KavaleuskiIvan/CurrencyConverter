//
//  CurrencyModel.swift
//  Currency Converter
//
//  Created by Kavaleuski Ivan on 26/05/2022.
//

import Foundation

struct Currency: Decodable {
    let data: [String: CurrencyValue]
}
struct CurrencyValue: Decodable {
    let code: String
    let value: Float
}
