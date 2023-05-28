//
//  Templates.swift
//  SmartDictionary
//
//  Created by Александра Кострова on 22.05.2023.
//

import UIKit
import CoreData

class Templates {
    
    public func showBottomSheet(_ currentViewController: UIViewController, bottomSheet: UIViewController) {
        let bottomSheet = bottomSheet
        let nav = UINavigationController(rootViewController: bottomSheet)
        nav.modalPresentationStyle = .pageSheet
        
        if let sheet = nav.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.prefersGrabberVisible = true
        }
        
        currentViewController.present(nav, animated: true, completion: nil)
    }
    
//    public func saveWordInfo(_ context: NSManagedObjectContext) {
//        do {
//            try context.save()
//            print("Word saved successfully!")
//        } catch {
//            print("Error saving word: \(error)")
//        }
//
//        UserDictionaryViewController().tableView.reloadData()
//    }
}

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
        
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange), name: UITextView.textDidChangeNotification, object: nil)
    }
    
    @objc private func textDidChange() {
        if let placeholderLabel = self.viewWithTag(13) as? UILabel {
            placeholderLabel.isHidden = !self.text.isEmpty
        }
    }
}

