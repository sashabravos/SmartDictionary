//
//  DictionaryViewController.swift
//  SmartDictionary
//
//  Created by Александра Кострова on 16.05.2023.
//

import UIKit

class DictionaryViewController: UIViewController, UISearchBarDelegate {
    
    var dictionaryManager = DictionaryManager()

    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "Search"
        return searchController
    }()
    
    private lazy var userDictionaryButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "My Dictionary", style: .plain, target: self, action: #selector(backToUserDictionary))
        button.tintColor = .label
        return button
    }()
    
    var dictionaryItems: [DictionaryModel] = [] // Массив с данными словаря

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        title = "Dictionary"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.leftBarButtonItem = userDictionaryButton
        
        dictionaryManager.delegate = self
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        setupCollectionView()
        setupConstraints()
        
        loadDataFromAPI()
    }
    
    func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(DictionaryCell.self, forCellWithReuseIdentifier: "DictionaryCell")
        view.addSubview(collectionView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func loadDataFromAPI() {
        // Загрузка всех английских слов из API
        let englishWords = ["bird", "world", "peace", "row", "bear", "banana"]// Замените на реальные английские слова или получите их из API
        for word in englishWords {
            dictionaryManager.getWordInfo(word: word)
        }
    }
}

extension DictionaryViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dictionaryItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DictionaryCell", for: indexPath) as! DictionaryCell
        let dictionaryItem = dictionaryItems[indexPath.item]
        
        cell.wordLabel.text = dictionaryItem.currentWord
        cell.transcriptionLabel.text = dictionaryItem.transcription
        cell.translationLabel.text = dictionaryItem.translation
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = collectionView.bounds.width - 20 // Ширина ячейки CollectionView с отступами
        let cellHeight: CGFloat = 100 // Высота ячейки CollectionView
        
        return CGSize(width: cellWidth, height: cellHeight)
    }

    // Add any additional UICollectionViewDelegateFlowLayout methods if needed
    // MARK: - UISearchBarDelegate
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // Фильтрация слов по тексту поиска
        filterWords(for: searchText)
        collectionView.reloadData()
    }
    
    func filterWords(for searchText: String?) {
        if let searchText = searchText {
            dictionaryItems = dictionaryItems.filter { $0.currentWord.lowercased().contains(searchText.lowercased()) }
        }
    }
    
    func isSearchActive() -> Bool {
        return searchController.isActive && !isSearchBarEmpty()
    }
    
    func isSearchBarEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    // MARK: - Button Actions
    
    @objc func backToUserDictionary() {
        let userDictionaryVC = UserDictionaryViewController()
        navigationController?.pushViewController(userDictionaryVC, animated: true)
    }
}

// MARK: - DictionaryManagerDelegate
extension DictionaryViewController: DictionaryManagerDelegate {
    func didUpdateData(_ dictionaryManager: DictionaryManager, dictionary: DictionaryModel) {
        DispatchQueue.main.async {
            self.dictionaryItems.append(dictionary)
            self.collectionView.reloadData()
        }
    }
        
    func didFailWithError(error: Error) {
        print("Error loading data: \(error)")
    }
}
