//
//  ExchangeService.swift
//  Le Baluchon
//
//  Created by damien on 27/06/2022.
//

import Foundation

//
// MARK: - Exchange Service
//
final class ExchangeService: ApiService {
    
    static var shared: ExchangeService = ExchangeService()
    
    private init(){}
    
    internal var session: URLSession = URLSession(configuration: .default)
    
    init(session: URLSession) {
        self.session = session
    }
    
    typealias DataRequest = ExchangeRequest
    typealias CallBackResponse = [String: Any]
    typealias DataResponse = ExchangeResponse
    
    private let userDefaults = UserDefaults.standard
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateStyle = .full
        formatter.timeZone = TimeZone.current
        return formatter
    }()
    
    private var base = Parameter(key : "base", value: "EUR")
    private var symbols = Parameter(key: "symbols", value: "USD")
    
    internal var parameters: [Parameter] {
        [base, symbols, apiKey(keyPlist: "ExchangeApiKey", keyParameter: "apikey")]
    }
    
    internal var httpMethod: HttpMethod { HttpMethod.get }
    internal var host: String { "api.apilayer.com" }
    internal var endPoint: String = ExchangeEndPoint.latest.rawValue
    internal var path: String  { "/fixer/" + endPoint }
    
    internal var task: URLSessionDataTask?
    
    private func populateParameters(dataRequest: DataRequest) {
        endPoint = dataRequest.endPoint.rawValue
        
        if dataRequest.endPoint == .latest, let baseCurrency = dataRequest.baseCurrency,
           let symbolCurrencies = dataRequest.symbolCurrencies  {
            self.base.value = baseCurrency
            symbols.value = symbolCurrencies.joined(separator: ",")
        }
    }
    
    func retrieveRatesFromUserDefault(dataRequest: DataRequest) -> [String: Double]? {
        if let rates = userDefaults.dictionary(forKey: Constants.RATES),
           let baseCurrency = dataRequest.baseCurrency,
           let symbolCurrencies = dataRequest.symbolCurrencies,
           let ratesFromBaseCurrency = rates[baseCurrency] as? [String: Double],
           symbolCurrencies.map({ key in ratesFromBaseCurrency.keys.contains(key)}).allSatisfy({
            isSatisfy in isSatisfy
           }) {
            return ratesFromBaseCurrency
        }
        return nil
    }
    
    func retrieveData(from dataRequest: DataRequest,
                      callBack: @escaping ([String: Any]?, NetworkError?) -> Void) {
        populateParameters(dataRequest: dataRequest)
        
        if !shouldBeUpdated() {
            switch dataRequest.endPoint {
            case .latest:
                if let rates = retrieveRatesFromUserDefault(dataRequest: dataRequest) {
                    callBack(rates, nil)
                    return
                }
            case .symbols:
                if let symbols = userDefaults.dictionary(forKey: Constants.SYMBOLS) {
                    callBack(symbols, nil)
                    return
                }
            }
        }
        
        performRequest(dataRequest: dataRequest) { data, error in
            callBack(data, error)
        }
    }
    
    private func shouldBeUpdated() -> Bool {
        if let lastDateUpdated = userDefaults.string(forKey: Constants.LAST_DATE_UPDATED) {
            return lastDateUpdated != dateFormatter.string(from: Date())
        }
        return true
    }
    
    private func performRequest(dataRequest: DataRequest, completion : @escaping (_ data: [String: Any]?, _ error: NetworkError?) -> Void)   {
        task?.cancel()
        task = retrieveTask(with: request) { data, response, error in
            DispatchQueue.main.async { [self] in
                if let networkError = handleError(data: data, response: response, error: error) {
                    return completion(nil, networkError)
                }
                
                guard let exchangeResponse = data else {
                    return
                }
                
                userDefaults.set(dateFormatter.string(from: Date()), forKey: Constants.LAST_DATE_UPDATED)
                
                switch dataRequest.endPoint {
                case .latest:
                    updateUserDefault(dataRequest: dataRequest, exchangeResponse: exchangeResponse)
                    completion(exchangeResponse.rates, nil)
                case .symbols:
                    userDefaults.set(exchangeResponse.symbols, forKey: Constants.SYMBOLS)
                    completion(exchangeResponse.symbols, nil)
                }
            }
        }
        task?.resume()
    }
    
    private func updateUserDefault(dataRequest: DataRequest, exchangeResponse: ExchangeResponse) {
        if let baseCurrency = dataRequest.baseCurrency {
            var cacheRates = userDefaults.dictionary(forKey: Constants.RATES) ?? [String: Any]()
            var ratesForBaseCurrency = cacheRates[baseCurrency] as? [String: Double] ?? [String: Double]()
            exchangeResponse.rates?.forEach { key, value in ratesForBaseCurrency[key] = value }
            
            cacheRates[baseCurrency] = ratesForBaseCurrency
            userDefaults.set(cacheRates, forKey: Constants.RATES)
        }
    }
}
