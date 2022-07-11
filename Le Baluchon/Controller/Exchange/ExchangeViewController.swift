//
//  ExchangeViewController.swift
//  Le Baluchon
//
//  Created by damien on 27/06/2022.
//

import UIKit

//
// MARK: - Exchange ViewController
//
class ExchangeViewController: UIViewController {

    @IBOutlet private weak var fromAmount: UITextField! {
        didSet {
            fromAmount.text = "1"
            fromAmount.addDoneCancelToolbar(onDone: (target: self, action: #selector(retrieveRates)))
        }
    }
    
    @IBOutlet private weak var toAmount: UITextField!
    
    var baseCurrency: String = Constants.DEFAULT_BASE_CURRENCY {
        willSet {
            baseCurrencyButton.setTitle(newValue, for: .normal)
            retrieveRates()
        }
    }
    
    var symbolCurrency: String = Constants.DEFAULT_SYMBOL_CURRENCY {
        willSet {
            symbolCurrencyButton.setTitle(newValue, for: .normal)
        }
    }
    
    lazy var baseCurrencyButton: UIButton = {
        let base = UIButton(type: .custom)
        base.setTitle(baseCurrency, for: .normal)
        base.setTitleColor(.black, for: .normal)
        base.backgroundColor = .none
        base.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        
        base.translatesAutoresizingMaskIntoConstraints = false
        base.addTarget(self, action: #selector(presentSymbolsViewController(_:)), for: .touchUpInside)
        return base
    }()
    
    lazy var keyboardButton: UIButton = {
        let base = UIButton(type: .custom)
        base.addTarget(self, action: #selector(openKeyboard(_:)), for: .touchUpInside)
        base.setImage(UIImage(named: "keyboard"), for: .normal)
        base.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        
        base.translatesAutoresizingMaskIntoConstraints = false
        return base
    }()
    
    @objc private func openKeyboard(_ sender: AnyObject) {
        fromAmount.becomeFirstResponder()
    }
    
    lazy var symbolCurrencyButton: UIButton = {
        let base = UIButton(type: .custom)
        base.setTitle(symbolCurrency, for: .normal)
        base.setTitleColor(.black, for: .normal)
        base.backgroundColor = .none
        base.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        
        base.translatesAutoresizingMaskIntoConstraints = false
        
        return base
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fromAmount.leftViewMode = .always
        fromAmount.leftView = baseCurrencyButton
        
        fromAmount.rightViewMode = .always
        fromAmount.rightView = keyboardButton
        
        fromAmount.layer.cornerRadius = 4.0
        fromAmount.layer.borderWidth = 1
        fromAmount.layer.borderColor = UIColor.orange.cgColor
        
        toAmount.leftViewMode = .always
        toAmount.leftView = symbolCurrencyButton
        
        retrieveRates()
    }

    @objc private func retrieveRates() {
        fromAmount.resignFirstResponder()
        ExchangeService.shared.retrieveData(
            from: ExchangeRequest(endPoint: .latest, baseCurrency: baseCurrencyButton.title(for: .normal)!, symbolCurrencies: [symbolCurrencyButton.title(for: .normal)!]), callBack: { [self] rates, error in
            guard error == nil else {
                return
            }
                
            if let rates = rates {
                let conversion = ((Double(fromAmount.text!)!) * (rates[symbolCurrency] as! Double))
                toAmount.text = "\(conversion)"
            }
        })
    }
    
    @objc private func presentSymbolsViewController(_ sender: AnyObject) {
        let symbolsViewController = SymbolsViewController()
        symbolsViewController.rootViewController = self
        present(symbolsViewController, animated: true, completion: nil)
    }
}
