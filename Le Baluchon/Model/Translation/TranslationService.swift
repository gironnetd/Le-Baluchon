//
//  TranslateService.swift
//  Le Baluchon
//
//  Created by damien on 23/06/2022.
//

import Foundation

//
// MARK: - Translate Service
//
final class TranslationService: ApiService {
    
    static var shared: TranslationService = TranslationService()
    
    private init(){}
    
    internal var session: URLSession = URLSession(configuration: .default)
    
    init(session: URLSession) {
        self.session = session
    }
    
    typealias DataRequest = String
    typealias CallBackResponse = String
    typealias DataResponse = TranslationResponse
    
    private lazy var q = Parameter(key: "q")
    private let target = Parameter(key : "target", value: "en")
    private let source = Parameter(key: "source", value: "fr")
    private let format = Parameter(key: "format", value: "text")
    
    internal var parameters: [Parameter] {
         [q, target, source, format, apiKey(keyPlist: "TranslationApiKey", keyParameter: "key")]
    }
    
    internal var httpMethod: HttpMethod { HttpMethod.post }
    internal var host: String { "translate.googleapis.com" }
    internal var endPoint: String = "translate/v2"
    internal var path: String { "/language/" + endPoint }
    
    internal var task: URLSessionDataTask?
    
    func retrieveData(from dataRequest: String, callBack: @escaping (String?, NetworkError?) -> Void) {
        populateParameters(dataRequest: dataRequest)
        
        task?.cancel()
        task = retrieveTask(with: request) { data, response, error in
            DispatchQueue.main.async { [self] in
                if let networkError = handleError(data: data, response: response, error: error) {
                    callBack(nil, networkError)
                    return
                }
                
                guard let translationResponse = data else {
                    return
                }
            
                callBack(translationResponse.data.translations[0].translatedText, nil)
            }
        }
        task?.resume()
    }
    
    func populateParameters(dataRequest: String) {
        q.value = dataRequest
    }
}
