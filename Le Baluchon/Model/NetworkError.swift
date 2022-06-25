//
//  NetworkError.swift
//  Le Baluchon
//
//  Created by damien on 23/06/2022.
//

import Foundation

//
// MARK: - Network Error
//
enum NetworkError: RawRepresentable,  Error {
    
    init?(rawValue: Int) {
        switch rawValue {
        case 404:
            self = .NotFound
        case 401:
            self = .Unauthorized
        case 403:
            self = .Forbidden
        case 400:
            self = .BadRequest
        case 429:
            self = .TooManyRequests
        case 500:
            self = .InternalServerError
        case 502:
            self = .BadGateway
        case 503:
            self = .ServiceUnavailable
        case 504:
            self = .GatewayTimedOut
        case 501:
            self = .NotImplemented
        default:
            self = .NotFound
        }
    }
    
    var rawValue: Int {
        switch self {
        case .NotFound:
            return 404
        case .Unauthorized:
            return 401
        case .Forbidden:
            return 403
        case .BadRequest:
            return 400
        case .TooManyRequests:
            return 429
        case .InternalServerError:
            return 500
        case .BadGateway:
            return 502
        case .ServiceUnavailable:
            return 503
        case .GatewayTimedOut:
            return 504
        case .NotImplemented:
            return 501
        }
    }
    
    typealias RawValue = Int
    
    //
    // MARK: - Cases
    // MARK: - Client-Side Errors
    case NotFound
    case Unauthorized
    case Forbidden
    case BadRequest
    case TooManyRequests
    
    // MARK: - Server-Side Errors
    case InternalServerError
    case BadGateway
    case ServiceUnavailable
    case GatewayTimedOut
    case NotImplemented
    
}
