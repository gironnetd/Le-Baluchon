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
    private var detectSession: URLSession = URLSession(configuration: .default)
    
    init(session: URLSession) {
        self.session = session
    }
    
    typealias DataRequest = String
    typealias CallBackResponse = (detection: String?,translation: String?)
    typealias DataResponse = TranslationResponse
    
    private lazy var q = Parameter(key: "q")
    private var target = Parameter(key : "target", value: UserDefaults.standard.string(forKey: Constants.TRANSLATION_LANGUAGE))
    private var source = Parameter(key: "source")
    private let format = Parameter(key: "format", value: "text")

    internal var httpMethod: HttpMethod { HttpMethod.post }
    internal var host: String { "translate.googleapis.com" }
    internal var endPoint: String = TranslationEndPoint.translate.rawValue
    internal var path: String {
        get { "/language/translate/v2" + endPoint }
        set {}
    }
    
    internal var parameters: [Parameter] {
        switch endPoint {
        case TranslationEndPoint.translate.rawValue:
            return [q, target, source, format, apiKey(keyPlist: "TranslationApiKey", keyParameter: "key")]
        case TranslationEndPoint.detect.rawValue:
            return [q, apiKey(keyPlist: "TranslationApiKey", keyParameter: "key")]
        case TranslationEndPoint.languages.rawValue:
            return [apiKey(keyPlist: "TranslationApiKey", keyParameter: "key")]
        default:
            return []
        }
    }
    
    internal var task: URLSessionDataTask?
    
    func detectLanguage(from dataRequest: String, callBack: @escaping (String?, NetworkError?) -> Void) {
        q.value = dataRequest
        self.endPoint = TranslationEndPoint.detect.rawValue
        
        task?.cancel()
        task = retrieveTask(with: request) { data, response, error in
            DispatchQueue.main.async { [self] in
                if let networkError = handleError(data: nil, response: response, error: error) {
                    callBack(nil, networkError)
                    return
                }
                
                guard let detectionResponse = data,
                      let detection = detectionResponse.data?.detections?[0]
                else {
                    callBack(nil, NetworkError.NotFound)
                    return
                }
            
                callBack(detection[0].language, nil)
            }
        }
        task?.resume()
    }
    
    func retrieveData(from dataRequest: String, callBack: @escaping ((detection: String?, translation: String?)?, NetworkError?) -> Void) {
        
        detectLanguage(from: dataRequest, callBack: { [self] detection, error in
            guard error == nil else {
                callBack((nil, nil), error)
                return
            }
            
            guard let detection = detection else {
                callBack((nil, nil), nil)
                return
            }
            
            callBack((detection, nil), nil)
            
            source.value = detection
            target.value = UserDefaults.standard.string(forKey: Constants.TRANSLATION_LANGUAGE)
            populateParameters(dataRequest: dataRequest)
            
            self.endPoint = TranslationEndPoint.translate.rawValue
            
            task?.cancel()
            task = retrieveTask(with: request) { data, response, error in
                DispatchQueue.main.async { [self] in
                    if let networkError = handleError(data: data, response: response, error: error) {
                        callBack((nil, nil), networkError)
                        return
                    }
                    
                    guard let translationResponse = data,
                          let translation = translationResponse.data?.translations else {
                        return
                    }
                
                    callBack((nil, translation[0].translatedText), nil)
                }
            }
            task?.resume()
        })
    }
    
    func populateParameters(dataRequest: String) {
        q.value = dataRequest
    }
    
    func retrieveLanguages(callBack: @escaping ([String]?, NetworkError?) -> Void) {
        self.endPoint = TranslationEndPoint.languages.rawValue
        
        task?.cancel()
        task = retrieveTask(with: request) { data, response, error in
            DispatchQueue.main.async { [self] in
                if let networkError = handleError(data: nil, response: response, error: error) {
                    callBack(nil, networkError)
                    return
                }
                
                guard let detectionResponse = data,
                      let languages = detectionResponse.data?.languages
                else {
                    callBack(nil, nil)
                    return
                }
            
                callBack(languages.map { language in language.language}, nil)
            }
        }
        task?.resume()
    }
}
