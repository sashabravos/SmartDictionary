//
//  ViewController.swift
//  SmartDictionary
//
//  Created by Александра Кострова on 15.05.2023.
//

import UIKit

final class UserDictionaryViewController: UITableViewController, UISearchBarDelegate {
    
    // MARK: - Properties
    
    private let viewModel = UserDictionaryViewModel()
    
    private let editBottomSheet = EditBottomSheet()
    private let addWordBottomSheet = AddWordBottomSheet()
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "Search"
        return searchController
    }()
    
    private lazy var floatingButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: ImageNames.plusButton), for: .normal)
        return button
    }()
    
    // MARK: - Bar Button Items
    
    private lazy var addButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Gallery", style: .plain, target: self,
                                     action: #selector(goToGallery))
        button.tintColor = .label
        return button
    }()
    
    private lazy var dictionaryButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Dictionary", style: .plain,
                                     target: self, action: #selector(goToDictionary))
        button.tintColor = .label
        return button
    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupNavigationBarItems()

        viewModel.setViewController(self)
        
        addWordBottomSheet.delegate = self
        editBottomSheet.delegate = self
        
        viewModel.loadWords()
        viewModel.groupWords()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        floatingButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            floatingButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -26),
            floatingButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            floatingButton.widthAnchor.constraint(equalToConstant: 65),
            floatingButton.heightAnchor.constraint(equalToConstant: 65)
        ])
    }
    
    // MARK: - Lifecycle methods
    
    private func setupNavigationBarItems() {
        title = "Your words 😜"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.barTintColor = UIColor(named: Colors.midKhaki)
        
        navigationItem.leftBarButtonItem = dictionaryButton
        navigationItem.rightBarButtonItem = addButton
        
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    private func setupViews() {
        
        tableView.backgroundColor = .white
        self.view.addSubview(floatingButton)
        
        floatingButton.addTarget(self, action: #selector(showAddWordBottomSheet), for: .touchUpInside)
        
        // Register cell
        tableView.register(UserCell.self, forCellReuseIdentifier: CellNames.userCell)
        
        tableView.reloadData()
    }
    
    // MARK: - UITableView DataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if isSearchActive() {
            return 1
        } else {
            return viewModel.wordDictionary.count
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if isSearchActive() {
            return nil
        } else {
            let sectionKey = Array(viewModel.wordDictionary.keys.sorted())[section]
            return sectionKey
        }
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        if isSearchActive() {
            return nil
        } else {
            return Array(viewModel.wordDictionary.keys.sorted())
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearchActive() {
            return viewModel.wordDictionary.values.flatMap({ $0 }).count
        } else {
            let sectionKey = Array(viewModel.wordDictionary.keys.sorted())[section]
            return viewModel.wordDictionary[sectionKey]?.count ?? 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellNames.userCell, for: indexPath) as! UserCell
        let word: String
        if isSearchActive() {
            let allWords = viewModel.wordDictionary.values.flatMap({ $0 })
            word = allWords[indexPath.row]
        } else {
            let sectionKey = Array(viewModel.wordDictionary.keys.sorted())[indexPath.section]
            word = viewModel.wordDictionary[sectionKey]![indexPath.row]
        }
        
        cell.textLabel?.text = word
        if let userWord = viewModel.wordsDatabaseInfo.first(where: { $0.text == word }) {
            cell.configure(with: userWord)
        }
        
        // Delete button
        cell.showsDeleteButton = true
        cell.deleteButtonAction = { [weak self] in
            self?.viewModel.deleteWord(at: indexPath)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCell.EditingStyle,
                            forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.deleteWord(at: indexPath)
        }
    }
    
    // MARK: - Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? UserCell {
            let editBottomSheet = EditBottomSheet()
            editBottomSheet.titleLabel.text = cell.cellTitle?.capitalized
            editBottomSheet.newWordTextView.text = cell.cellTitle
            editBottomSheet.translationTextView.text = cell.cellTitleTranslation
            editBottomSheet.exampleTextView.text = cell.cellTitleExample
            
            if let word = viewModel.wordsDatabaseInfo.first(where: { $0.text == cell.cellTitle }) {
                editBottomSheet.userWord = word
            }
            
            showBottomSheet(self, bottomSheet: editBottomSheet)
        } else {
            print("Failed to get UserCell")
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - UISearchBarDelegate
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.filterWords(for: searchText)
        tableView.reloadData()
    }
    
    func isSearchActive() -> Bool {
        return searchController.isActive && !isSearchBarEmpty()
    }
    
    func isSearchBarEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    // MARK: - Floating Button
        
    @objc private func showAddWordBottomSheet() {
       showBottomSheet(self, bottomSheet: addWordBottomSheet)
    }
    
    // MARK: - NavigationBarButton's action
    
    @objc private func goToDictionary() {
        let dictionaryViewController = DictionaryViewController()
        navigationController?.pushViewController(dictionaryViewController, animated: true)
    }
    
    @objc private func goToGallery() {
        let galleryViewController = GalleryViewController()
        navigationController?.pushViewController(galleryViewController, animated: true)
    }
}

// MARK: - AddWordBottomSheetDelegate

extension UserDictionaryViewController: AddWordBottomSheetDelegate {
    func addWord(_ word: UserWord) {
        viewModel.addNewWord(word)
    }
}

// MARK: - EditBottomSheetDelegate

extension UserDictionaryViewController: EditBottomSheetDelegate {
    func updateWord(_ word: UserWord) {
        viewModel.changeWord(word)
    }
}
