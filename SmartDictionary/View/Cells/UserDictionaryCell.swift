//
//  UserDictionaryCell.swift
//  SmartDictionary
//
//  Created by Александра Кострова on 16.05.2023.
//

import UIKit

class UserCell: UITableViewCell {
    
    static let identifier = Keys.userCell
    
    var cellTitle: String?
    var cellTitleTranslation: String?
    var cellTitleExample: String?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with word: UserWord) {
        cellTitle = word.text
        cellTitleTranslation = word.translation
        cellTitleExample = word.example
    }
}
