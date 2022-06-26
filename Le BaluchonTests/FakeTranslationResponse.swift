//
//  FakeTranslationResponse.swift
//  Le BaluchonTests
//
//  Created by damien on 25/06/2022.
//

import Foundation

class FakeTranslationResponse {

    static var correctTranslation: Data? {
       let bundle = Bundle(for: FakeTranslationResponse.self)
       let url = bundle.url(forResource: "TranslationResponse", withExtension: "json")!
       return try! Data(contentsOf: url)
    }
    
    static let incorrectTranslation = "erreur".data(using: .utf8)!
}
