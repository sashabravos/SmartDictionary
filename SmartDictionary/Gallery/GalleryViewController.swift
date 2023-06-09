//
//  GalleryViewController.swift
//  SmartDictionary
//
//  Created by Александра Кострова on 01.06.2023.
//

import UIKit

final class GalleryViewController: UIViewController {
        
    var cellWidth: CGFloat = 0
    var cellHeight: CGFloat = 0
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
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
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Picture dictionary"
        navigationController?.navigationBar.prefersLargeTitles = true
                
        setViews()
        
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let numberOfColumns: CGFloat = 3
        let totalSpacing: CGFloat = 12
        let availableWidth = collectionView.bounds.width - totalSpacing * numberOfColumns
        cellWidth = CGFloat(Int(availableWidth / numberOfColumns))
        cellHeight = 170
    }
    
    // MARK: - Lifecycle methods
    
    private func setViews() {
        collectionView.backgroundColor = .white
        
        [collectionView, cameraButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            cameraButton.trailingAnchor.constraint(equalTo: collectionView.trailingAnchor, constant: -26),
            cameraButton.bottomAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: -42)
        ])
        
        cameraButton.addTarget(self, action: #selector(showPopoverViewController), for: .touchUpInside)
    }
    
    @objc private func showPopoverViewController() {
        let popVC = PopViewController()
        
        popVC.preferredContentSize = CGSize(width: 200, height: 130)
        popVC.modalPresentationStyle = .popover
        popVC.presentationController?.delegate = self
        
        if let pop = popVC.popoverPresentationController {
            pop.sourceView = self.view
            
            let offset: CGFloat = 170
            let sourceRectY = self.view.bounds.height - offset

            pop.sourceRect = CGRect(x: self.view.bounds.maxX, y: sourceRectY, width: 0, height: 0)

            pop.permittedArrowDirections = []
        }
        
        navigationController?.present(popVC, animated: true)
    }
}

extension GalleryViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController,
                                   traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
}

// MARK: - Collection View Methods

extension GalleryViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return TestModel.shared.imageNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCell.identifier,
                                                         for: indexPath) as? ImageCell {
            let image = TestModel.shared.images[indexPath.row]
            let title = TestModel.shared.imageNames[indexPath.row]
            
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
