//
//  DictionaryCell.swift
//  SmartDictionary
//
//  Created by Александра Кострова on 16.05.2023.
//

import UIKit

class DictionaryCell: UITableViewCell {
    
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
    
    private lazy var addButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(addToUserDictionary), for: .touchUpInside)
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.tintColor = .systemBlue
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
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
        contentView.addSubview(addButton)
        
        // Constraints
        NSLayoutConstraint.activate([
            wordLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            wordLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            wordLabel.trailingAnchor.constraint(equalTo: addButton.leadingAnchor, constant: -8), // Обновлено ограничение для выравнивания кнопки справа
            
            transcriptionLabel.topAnchor.constraint(equalTo: wordLabel.bottomAnchor, constant: 2),
            transcriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            transcriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            
            translationLabel.topAnchor.constraint(equalTo: transcriptionLabel.bottomAnchor, constant: 4),
            translationLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            translationLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            translationLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            addButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            addButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8), // Обновлено ограничение для размещения кнопки справа
            addButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            addButton.widthAnchor.constraint(equalToConstant: 44), // Установлено фиксированное значение ширины кнопки
        ])
    }
    
    func configure(with dictionaryItem: DictionaryModel) {
        wordLabel.text = dictionaryItem.currentWord
        transcriptionLabel.text = dictionaryItem.transcription
        translationLabel.text = dictionaryItem.translation
    }
    
    @objc func addToUserDictionary() {
        // Действие кнопки "Добавить"
    }
}
