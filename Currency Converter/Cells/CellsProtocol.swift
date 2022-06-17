//
//  CellsProtocol.swift
//  Currency Converter
//
//  Created by Kavaleuski Ivan on 17/06/2022.
//

import Foundation

protocol ReusableView {
    static var reuseIdentifier: String { get }
}

extension ReusableView {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
