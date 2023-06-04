//
//  Templates.swift
//  SmartDictionary
//
//  Created by Александра Кострова on 22.05.2023.
//

import UIKit

final class CommonMethods {
    
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
}
