//
//  UserCell.swift
//  SmartDictionary
//
//  Created by Александра Кострова on 16.05.2023.
//

import UIKit

class UserCell: UITableViewCell {
    
    static let identifier = CellNames.userCell
    
    var showsDeleteButton: Bool = false {
            didSet {
                updateDeleteButtonVisibility()
            }
        }
    
    var deleteButtonAction: (() -> Void)?
        
        private lazy var deleteButton: UIButton = {
            let button = UIButton(type: .system)
            button.setImage(UIImage(systemName: "trash"), for: .normal)
            button.tintColor = .systemRed
            button.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
            return button
        }()
    
    var cellTitle: String?
    var cellTitleTranslation: String?
    var cellTitleExample: String?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func updateDeleteButtonVisibility() {
            deleteButton.isHidden = !showsDeleteButton
        }
        
        @objc private func deleteButtonTapped() {
            deleteButtonAction?()
        }
    
    func configure(with word: UserWord) {
        
        backgroundColor = .white
        
        cellTitle = word.text
        cellTitleTranslation = word.translation
        cellTitleExample = word.example
        
        updateDeleteButtonVisibility()
    }
}
