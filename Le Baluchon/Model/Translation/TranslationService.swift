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
    
    internal var endPoint: String {
        "https://translate.googleapis.com/"
    }
    
    private let basic = "language/translate/v2"
    
    internal var url: URL {
        URL(string: endPoint + basic)!
    }
    
    private lazy var q = Parameter(key: "q", value: "", description: "")
    private let target = Parameter(key : "target", value: "en", description: "")
    private let source = Parameter(key: "source", value: "fr", description: "")
    private let format = Parameter(key: "format", value: "text", description: "")
    private var apiKey: Parameter {
        let filePath = Bundle.main.path(forResource: "ApiKeys", ofType: "plist")
        let apiKeys = NSDictionary(contentsOfFile:filePath!)
        let value = apiKeys?.object(forKey: "TranslationApiKey") as! String
        return Parameter(key: "key", value: value, description: "")
    }
    
    internal var parameters: [Parameter] {
        [q, target, source, format, apiKey]
    }
    
    internal var request: URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = parameters.reduce(into: "", { result, parameter in
            result.append("\(parameter.key)=\(parameter.value)")
            if let lastParameter = parameters.last , parameter != lastParameter {
                result.append("&")
            }
        }).data(using: .utf8)
        return request
    }
    
    func retrieveData(from dataRequest: String, callBack: @escaping (String?, NetworkError?) -> Void) {
        q.value = dataRequest.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        let task = retrieveTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                guard let response = response as? HTTPURLResponse else {
                    callBack(nil, NetworkError.NotImplemented)
                    return
                }
                
                guard response.statusCode == 200 else  {
                    callBack(nil, NetworkError(rawValue: response.statusCode))
                    return
                }
                
                guard let translation = data, error == nil else {
                    callBack(nil, NetworkError.NotFound)
                    return
                }
            
                callBack(translation.data.translations[0].translatedText, nil)
            }
        }
        task.resume()
    }
}
