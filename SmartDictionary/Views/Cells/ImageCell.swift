//
//  GalleryCell.swift
//  SmartDictionary
//
//  Created by Александра Кострова on 01.06.2023.
//

import UIKit

//
//protocol ImageSelectionDelegate: AnyObject {
//    func didSelectImage(_ image: UIImage?, withDescription description: String?)
//}

class ImageCell: UICollectionViewCell {
    
    static let identifier = "ImageCell"
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .systemBackground
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .label
        label.textAlignment = .center
        label.numberOfLines = 0
        label.layer.borderWidth = 1
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
        self.layer.borderWidth = 1
        
        [imageView, titleLabel].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: contentView.frame.height * 0.2)
        ])
    }
    
    func configure(with image: UIImage, title: String) {
        imageView.image = image
        titleLabel.text = title
    }
    
    //    func loadImageFromURL(_ url: URL) {
    //        // Загрузка картинки из интернета
    //        // ...
    //
    ////        imageView.image = loadedImage
    ////        delegate?.didSelectImage(loadedImage, withDescription: nil)
    //    }
    //
    //    func takePhoto() {
    //        // Сделать снимок
    //        // ...
    //
    ////        imageView.image = capturedImage
    ////        delegate?.didSelectImage(capturedImage, withDescription: nil)
    //    }
}
