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
    
    associatedtype DataRequest
    associatedtype CallBackResponse
    associatedtype DataResponse where DataResponse: Decodable , DataResponse: Encodable
    
    static var shared: Self { get }
    
    typealias Parameter = (key: String, value: String, description: String)
    
    var endPoint: String { get }
    var url: URL { get }
    var parameters: [Parameter] { get }
    var request: URLRequest { get }
    
    var session: URLSession { get set }

    func retrieveData(from dataRequest: DataRequest, callBack: @escaping (CallBackResponse?, NetworkError?) -> Void)
}

extension ApiService {
    func retrieveTask(with request: URLRequest, completionHandler: @escaping (Self.DataResponse?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return session.codableTask(with: request, completionHandler: completionHandler)
    }
}
