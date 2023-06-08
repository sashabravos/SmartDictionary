//
//  SearchViewController.swift
//  SmartDictionary
//
//  Created by Александра Кострова on 06.06.2023.
//

import UIKit

final class SearchViewController: UIViewController {
    
    private var timer: Timer?
    private let imageResponse = ImageResponse()
    
    private var imageArray = [UnsplashPhoto]()
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "Search"
        return searchController
    }()
    
    private lazy var addBarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addImageToGallery))
    }()
    
    private lazy var cancelBarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonTapped))
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 2
        layout.minimumInteritemSpacing = 2
        layout.sectionInset = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(SearchImageCell.self, forCellWithReuseIdentifier: SearchImageCell.identifier)
        return collectionView
    }()
    
    var cellWidth: CGFloat = 0
    var cellHeight: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = cancelBarButtonItem
        navigationItem.rightBarButtonItem = addBarButtonItem
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
        
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.backgroundColor = .white
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let numberOfColumns: CGFloat = 3
        let totalSpacing: CGFloat = 3
        let availableWidth = collectionView.bounds.width - totalSpacing * numberOfColumns
        cellWidth = CGFloat(Int(availableWidth / numberOfColumns))
        cellHeight = cellWidth
    }
    
    @objc func addImageToGallery() {
        print("add picture")
    }
    
    @objc func cancelButtonTapped() {
        self.dismiss(animated: true)
    }
}

// MARK: - Collection View Methods

extension SearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchImageCell.identifier,
                                                         for: indexPath) as? SearchImageCell {
            
            let image = imageArray[indexPath.item]
            cell.unsplashImage = image
            return cell
            
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! SearchImageCell
        guard let image = cell.imageView.image else { return }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! SearchImageCell
        guard let image = cell.imageView.image else { return }
    }
}

extension SearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellWidth, height: cellHeight)
    }
}

// MARK: - UISearchBarDelegate

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false,
                                     block: { (_) in
            self.imageResponse.fetchImages(for: searchText) { [weak self] (searchResults) in
                guard let fetchedPhotos = searchResults else { return }
                self?.imageArray = fetchedPhotos.results
                self?.collectionView.reloadData()
            }
        })
    }
}
