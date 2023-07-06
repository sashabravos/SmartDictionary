//
//  WelcomeViewController.swift
//  SmartDictionary
//
//  Created by Александра Кострова on 16.05.2023.
//

import UIKit

final class WelcomeViewController: UIViewController {
    
    private let welcomeView = WelcomeView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        welcomeView.delegate = self
        setMyView(welcomeView, self.view)
        
        let swipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        swipeGestureRecognizer.direction = .up
        view.addGestureRecognizer(swipeGestureRecognizer)
    }
}

extension WelcomeViewController: WelcomeViewDelegate {
    @objc func handleSwipe() {
        let secondVC = UserDictionaryViewController()
        let transition = CATransition()
        transition.duration = 0.8
        transition.type = .push
        transition.subtype = .fromTop
        view.window?.layer.add(transition, forKey: kCATransition)
        navigationController?.popViewController(animated: false)
        navigationController?.pushViewController(secondVC, animated: false)
    }
}
