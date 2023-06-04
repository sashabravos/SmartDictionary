//
//  ClassExtensions.swift
//  SmartDictionary
//
//  Created by Александра Кострова on 04.06.2023.
//

import UIKit

extension UITextView {
    
    func addPlaceholder(text: String) {
        let placeholderLabel = UILabel()
        placeholderLabel.text = text
        placeholderLabel.font = UIFont.systemFont(ofSize: 20)
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.tag = 13
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(placeholderLabel)
        
        NSLayoutConstraint.activate([
            placeholderLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 15),
            placeholderLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            placeholderLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8),
            placeholderLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8)
        ])
        
        placeholderLabel.isHidden = !self.text.isEmpty
        
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange),
                                               name: UITextView.textDidChangeNotification, object: nil)
    }
    
    @objc private func textDidChange() {
        if let placeholderLabel = self.viewWithTag(13) as? UILabel {
            placeholderLabel.isHidden = !self.text.isEmpty
        }
    }
}
