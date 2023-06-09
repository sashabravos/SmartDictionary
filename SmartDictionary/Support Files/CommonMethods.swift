//
//  Templates.swift
//  SmartDictionary
//
//  Created by Александра Кострова on 22.05.2023.
//

import UIKit

final class CommonMethods {
    
    // MARK: - For logical code separation
    
    public func setMyView(_ myView: UIView, _ replaceView: UIView) {
        replaceView.addSubview(myView)
        myView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            myView.topAnchor.constraint(equalTo: replaceView.topAnchor),
            myView.leadingAnchor.constraint(equalTo: replaceView.leadingAnchor),
            myView.trailingAnchor.constraint(equalTo: replaceView.trailingAnchor),
            myView.bottomAnchor.constraint(equalTo: replaceView.bottomAnchor)
        ])
    }
    
// MARK: - BottomSheet's Methods and Views
    
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
    
    public func anyTextView(_ placeholder: String = "") -> UITextView {
        let textView = UITextView()
        textView.addPlaceholder(text: placeholder)
        textView.font = UIFont.systemFont(ofSize: 20)
        textView.textColor = .black
        textView.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1.0)
        textView.isEditable = true
        textView.isScrollEnabled = true
        textView.layer.cornerRadius = 10
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.textContainerInset = UIEdgeInsets(top: 15, left: 8, bottom: 4, right: 8)
        
        return textView
    }
    
    public func bottomSheetTitleLabel(_ labelText: String = "") -> UILabel {
        let label = UILabel()
        label.text = labelText
        label.font = UIFont.systemFont(ofSize: 32, weight: .semibold)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }
    
    public func bottomSheetBigButton(title: String) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .light)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(named: Colors.midKhaki)
        button.layer.cornerRadius = 8
        return button
    }
}
