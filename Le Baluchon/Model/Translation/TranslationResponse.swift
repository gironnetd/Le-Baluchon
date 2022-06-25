//
//  TranslationResponse.swift
//  Le Baluchon
//
//  Created by damien on 23/06/2022.
//

import Foundation

// MARK: - TranslationResponse
struct TranslationResponse: Codable {
    let data: Data
}

// MARK: - Data
struct Data: Codable {
    let translations: [Translation]
}

// MARK: - Translation
struct Translation: Codable {
    let translatedText: String
}

