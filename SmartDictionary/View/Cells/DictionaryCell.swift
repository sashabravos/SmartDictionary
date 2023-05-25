//
//  DictionaryCell.swift
//  SmartDictionary
//
//  Created by Александра Кострова on 16.05.2023.
//

import UIKit

class DictionaryCell: UICollectionViewCell {
    
    // MARK: - UI Elements
    
    let wordLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let transcriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let translationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupViews()
    }
    
    // MARK: - View Setup
    
    private func setupViews() {
        contentView.addSubview(wordLabel)
        contentView.addSubview(transcriptionLabel)
        contentView.addSubview(translationLabel)
        
        // Constraints
        NSLayoutConstraint.activate([
            wordLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            wordLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            wordLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            
            transcriptionLabel.topAnchor.constraint(equalTo: wordLabel.bottomAnchor, constant: 2),
            transcriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            transcriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            
            translationLabel.topAnchor.constraint(equalTo: transcriptionLabel.bottomAnchor, constant: 4),
            translationLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            translationLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            translationLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    func configure(with dictionaryModel: DictionaryModel) {
        wordLabel.text = dictionaryModel.currentWord
        transcriptionLabel.text = dictionaryModel.transcription
        translationLabel.text = dictionaryModel.translation
    }
}
