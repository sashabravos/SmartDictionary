//
//  SearchImageCell.swift
//  SmartDictionary
//
//  Created by Александра Кострова on 06.06.2023.
//

import UIKit
import SDWebImage

class SearchImageCell: UICollectionViewCell {
    
    static let identifier = CellNames.searchImageCell
    
    let checkmark: UIImageView = {
        let image = UIImage(named: ImageNames.checkmark)
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.alpha = 0
        return imageView
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    var unsplashImage: UnsplashPhoto! {
        didSet {
            let photoURL = unsplashImage.urls["regular"]
            guard let imageURL = photoURL, let url = URL(string: imageURL) else { return }
            imageView.sd_setImage(with: url)
        }
    }
    
    override var isSelected: Bool {
        didSet {
            updateSelectedState()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        updateSelectedState()
        setupImageView()
        setupCheckmark()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func updateSelectedState() {
        imageView.alpha = isSelected ? 0.7 : 1
        checkmark.alpha = isSelected ? 1 : 0
    }
    
    private func setupImageView() {
        
        contentView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    private func setupCheckmark() {
        
        contentView.addSubview(checkmark)
        NSLayoutConstraint.activate([
            checkmark.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -8),
            checkmark.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -8)
        ])
    }
}
