//
//  ApiService.swift
//  Le Baluchon
//
//  Created by damien on 25/06/2022.
//

import Foundation

//
// MARK: - Api Service
//
protocol ApiService {
    
    associatedtype DataResponse
    associatedtype DataRequest
    
    typealias Parameter = (key: String, value: String, description: String)
    
    var endPoint: String { get }
    var url: URL { get }
    var parameters: [Parameter] { get }
    var request: URLRequest { get }
    
    func retrieveData(from dataRequest: DataRequest, callBack: @escaping (DataResponse?, NetworkError?) -> Void)
}

extension ApiService {
    func retrieveTask(with request: URLRequest, completionHandler: @escaping (TranslationResponse?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return URLSession.shared.codableTask(with: request, completionHandler: completionHandler)
    }
}
