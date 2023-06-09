//
//  PopCell.swift
//  SmartDictionary
//
//  Created by Александра Кострова on 05.06.2023.
//

import UIKit

final class PopCell: UITableViewCell {

    static let identifier = CellNames.popCell
    
    lazy var cellTitle: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
                
        backgroundColor = .white
        
        cellTitle.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(cellTitle)
        
        // Constraints
        NSLayoutConstraint.activate([
            cellTitle.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            cellTitle.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
    }
}
