//
//  WelcomeView.swift
//  SmartDictionary
//
//  Created by Александра Кострова on 03.06.2023.
//

import UIKit

protocol WelcomeViewDelegate: AnyObject {
    func handleSwipe()
}

class WelcomeView: UIView {
    
    weak var delegate: WelcomeViewDelegate?
    
    private lazy var welcomeLabel = anyLabel(text: "Welcome to the Smart Dictionary!")
    private lazy var swipeLabel = anyLabel(text: "Swipe to go!")
    
    private lazy var arrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.up")
        imageView.tintColor = .label
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setSubViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setSubViews() {
        
        self.backgroundColor = UIColor(named: Colors.backgroundColor)
        
        [welcomeLabel, arrowImageView, swipeLabel].forEach {
            self.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            welcomeLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -20.0),
            welcomeLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 20.0),
            welcomeLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 100),
            
            arrowImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            arrowImageView.widthAnchor.constraint(equalToConstant: 80.0),
            arrowImageView.heightAnchor.constraint(equalToConstant: 80.0),
            
            swipeLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            swipeLabel.topAnchor.constraint(equalTo: arrowImageView.bottomAnchor, constant: 20),
            swipeLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -150.0)
        ])
    }
}

extension WelcomeView {
    
    private func anyLabel(text: String) -> UILabel {
            let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 40.0, weight: .light)
            label.textAlignment = .center
            label.textColor = .label
            label.numberOfLines = 0
            label.text = text
            
            return label
    }
}
