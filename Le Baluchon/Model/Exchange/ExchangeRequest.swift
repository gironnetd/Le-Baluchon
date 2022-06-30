//
//  ExchangeRequest.swift
//  Le Baluchon
//
//  Created by damien on 29/06/2022.
//

import Foundation

//
// MARK: - ExchangeRequest
//
struct ExchangeRequest {
    var endPoint: ExchangeEndPoint
    var baseCurrency: String?
    var symbolCurrencies: [String]?
}
