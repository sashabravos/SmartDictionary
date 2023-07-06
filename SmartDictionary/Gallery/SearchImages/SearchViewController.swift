//
//  SearchViewController.swift
//  SmartDictionary
//
//  Created by Александра Кострова on 06.06.2023.
//

import UIKit
import SDWebImage

final class SearchViewController: UIViewController {
    
//    private var timer: Timer?
    private let imageResponse = ImageResponse()
    
    private var imageArray = [UnsplashPhoto]()
    
    var cellWidth: CGFloat = 0
    var cellHeight: CGFloat = 0
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 2
        layout.minimumInteritemSpacing = 2
        layout.sectionInset = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(SearchImageCell.self, forCellWithReuseIdentifier: SearchImageCell.identifier)
        return collectionView
    }()

    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "Search"
        searchController.searchBar.setValue("Done", forKey: "cancelButtonText")
        return searchController
    }()
    
    private lazy var cancelBarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonTapped))
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBarItems()
        setupCollectionView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let numberOfColumns: CGFloat = 3
        let totalSpacing: CGFloat = 3
        let availableWidth = collectionView.bounds.width - totalSpacing * numberOfColumns
        cellWidth = CGFloat(Int(availableWidth / numberOfColumns))
        cellHeight = cellWidth
    }
    
    // MARK: - Lifecycle methods
    
    private func setupNavigationBarItems() {
        navigationItem.leftBarButtonItem = cancelBarButtonItem
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
    }
    
    private func setupCollectionView() {
        
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.backgroundColor = .white
        collectionView.allowsMultipleSelection = true

    }
    
    // MARK: - Button actions

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
        
//        timer?.invalidate()
//        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false,
//                                     block: { (_) in
//        print(searchText)
//        afterBlock(seconds: 3) {
//            self.imageResponse.fetchImages(for: searchText) { [weak self] (searchResults) in
//                guard let fetchedPhotos = searchResults else { return }
//                self?.imageArray = fetchedPhotos.results
//                self?.collectionView.reloadData()
//            }
//        }

//        })
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else { return }
        self.imageResponse.fetchImages(for: searchText) { [weak self] (searchResults) in
            guard let fetchedPhotos = searchResults else { return }
            self?.imageArray = fetchedPhotos.results
            self?.collectionView.reloadData()
        }
    }
    
    func afterBlock( seconds: Int, queue: DispatchQueue =
                     DispatchQueue.global(), completion: @escaping ()->()) {
        queue.asyncAfter (deadline: .now() + .seconds (seconds) ) {
            completion()
        }
    }
}
