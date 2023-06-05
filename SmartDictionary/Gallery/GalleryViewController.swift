//
//  GalleryViewController.swift
//  SmartDictionary
//
//  Created by Александра Кострова on 01.06.2023.
//

import UIKit

class GalleryViewController: UIViewController {
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(ImageCell.self, forCellWithReuseIdentifier: ImageCell.identifier)
        return collectionView
    }()
    
    private lazy var cameraButton: UIButton = {
        let button = UIButton()
        
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 40, weight: .regular, scale: .large)
        let largeCamera = UIImage(systemName: ImageNames.cameraButton, withConfiguration: largeConfig)
        button.setImage(largeCamera, for: .normal)
        button.backgroundColor = .clear
        button.tintColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var cellWidth: CGFloat = 0
    var cellHeight: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // setup navigationBar items
        title = "Gallery"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        view.addSubview(collectionView)
        view.addSubview(cameraButton)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            cameraButton.trailingAnchor.constraint(equalTo: collectionView.trailingAnchor, constant: -26),
            cameraButton.bottomAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: -42)
        ])
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        cameraButton.addTarget(self, action: #selector(showPopoverViewController), for: .touchUpInside)
        
        collectionView.backgroundColor = .white
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let numberOfColumns: CGFloat = 3
        let totalSpacing: CGFloat = 12
        let availableWidth = collectionView.bounds.width - totalSpacing * numberOfColumns
        cellWidth = CGFloat(Int(availableWidth / numberOfColumns))
        cellHeight = 170
    }
    
    @objc private func showPopoverViewController() {
        let popVC = PopViewController()
//        popVC.delegate = self
        
        present(popVC, animated: true)
    }
}

extension GalleryViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCell.identifier,
                                                         for: indexPath) as? ImageCell {
            let image = UIImage(named: "CookieMonster")
            let title = "CookieMonster"
            
            cell.configure(with: image ?? UIImage(), title: title)
            
            return cell
        }
        return UICollectionViewCell()
    }
}

extension GalleryViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellWidth, height: cellHeight)
    }
}
