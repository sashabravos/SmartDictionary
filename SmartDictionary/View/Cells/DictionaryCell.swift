//
//  DictionaryCell.swift
//  SmartDictionary
//
//  Created by Александра Кострова on 16.05.2023.
//

import UIKit

class DictionaryCell: UICollectionViewCell {
    
    let wordLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    
    let translationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    
    let exampleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        addSubview(wordLabel)
        addSubview(translationLabel)
        addSubview(exampleLabel)
        
        // Setup title
        NSLayoutConstraint.activate([
            wordLabel.topAnchor.constraint(equalTo: topAnchor),
            wordLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            wordLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
        
        // Setup translation
            translationLabel.topAnchor.constraint(equalTo: wordLabel.bottomAnchor),
            translationLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            translationLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            
        // Setup example
            exampleLabel.topAnchor.constraint(equalTo: translationLabel.bottomAnchor, constant: 2),
            exampleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            exampleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            exampleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4)
        ])
    }
}

