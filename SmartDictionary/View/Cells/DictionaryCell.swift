//
//  DictionaryCell.swift
//  SmartDictionary
//
//  Created by Александра Кострова on 16.05.2023.
//

import UIKit

final class DictionaryCell: UITableViewCell {
    
    static let identifier = Keys.dictionaryCell
    
    private lazy var wordLabel = UILabel()
    private lazy var transcriptionLabel = UILabel()
    private lazy var translationLabel = UILabel()
    lazy var addButton = UIButton()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - View Setup
    
    private func setupViews() {
        
        configUI()
        
        [wordLabel, transcriptionLabel, translationLabel, addButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        // Constraints
        NSLayoutConstraint.activate([
            wordLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            wordLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            wordLabel.trailingAnchor.constraint(equalTo: addButton.leadingAnchor, constant: -8),
            
            transcriptionLabel.topAnchor.constraint(equalTo: wordLabel.bottomAnchor, constant: 2),
            transcriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            transcriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            
            translationLabel.topAnchor.constraint(equalTo: transcriptionLabel.bottomAnchor, constant: 4),
            translationLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            translationLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            translationLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            addButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            addButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            addButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            addButton.widthAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    func configure(with dictionaryItem: DictionaryModel) {
        wordLabel.text = dictionaryItem.currentWord
        transcriptionLabel.text = dictionaryItem.transcription
        translationLabel.text = dictionaryItem.translation
    }
    
    
}

// MARK: - Private Extensions

private extension DictionaryCell {
    func configUI() {
    
        wordLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        wordLabel.textColor = .black
        
        transcriptionLabel.font = UIFont.systemFont(ofSize: 12)
        transcriptionLabel.textColor = .gray
        
        translationLabel.font = UIFont.systemFont(ofSize: 14)
        translationLabel.textColor = .darkGray
        
        addButton.setImage(UIImage(systemName: "plus"), for: .normal)
        addButton.tintColor = .label
    }
}
