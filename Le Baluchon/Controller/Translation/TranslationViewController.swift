//
//  TranslationViewController.swift
//  Le Baluchon
//
//  Created by damien on 23/06/2022.
//

import UIKit

//
// MARK: - Translation ViewController
//
class TranslationViewController: UIViewController {
    
    @IBOutlet private weak var fromTranslation: UITextView!
    @IBOutlet private weak var toTranslation: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func translate() {
        TranslationService.shared.retrieveData(from: fromTranslation.text) { translation, error in
            guard error == nil else {
                return
            }
            
            if let translation = translation {
                self.toTranslation.text = translation
            }
        }
    }
}

extension TranslationViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        fromTranslation.text = ""
        toTranslation.text = ""
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            fromTranslation.resignFirstResponder()
            translate()
            return false
        }
        return true
    }
}


