//
//  WelcomeViewController.swift
//  SmartDictionary
//
//  Created by Александра Кострова on 16.05.2023.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    let welcomeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 35.0, weight: .bold)
        label.textAlignment = .center
        label.textColor = .label
        label.numberOfLines = 0
        label.text = "Welcome to the Smart Dictionary!"
        
        return label
    }()

    let arrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "arrow.up.circle")
        imageView.tintColor = .label
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    let swipeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        label.textAlignment = .center
        label.textColor = .label
        label.text = "Swipe to go!"
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(welcomeLabel)
        view.addSubview(arrowImageView)
        view.addSubview(swipeLabel)
        
        let swipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        swipeGestureRecognizer.direction = .up
        view.addGestureRecognizer(swipeGestureRecognizer)

        NSLayoutConstraint.activate([
            welcomeLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20.0),
            welcomeLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20.0),
            welcomeLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            
            arrowImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            arrowImageView.widthAnchor.constraint(equalToConstant: 80.0),
            arrowImageView.heightAnchor.constraint(equalToConstant: 80.0),
            
            swipeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            swipeLabel.topAnchor.constraint(equalTo: arrowImageView.bottomAnchor, constant: 20),
            swipeLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -220.0)
        ])
    }

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


