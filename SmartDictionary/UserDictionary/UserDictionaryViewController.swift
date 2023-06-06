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
    
    private let commonMethods = CommonMethods()
    private let editBottomSheet = EditBottomSheet()

    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "Search"
        return searchController
    }()
    
    private lazy var floatingButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: ImageNames.plusButton), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(button)
        NSLayoutConstraint.activate([
            button.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -26),
            button.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            button.widthAnchor.constraint(equalToConstant: 65),
            button.heightAnchor.constraint(equalToConstant: 65)
        ])
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
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.setViewController(self)
        
        editBottomSheet.delegate = self
        
        tableView.backgroundColor = .white
        navigationController?.navigationBar.barTintColor = UIColor(named: Colors.midKhaki)
        
        // Setup navigationBar items
        title = "Your words 😜"
        navigationController?.navigationBar.prefersLargeTitles = true

        navigationItem.leftBarButtonItem = dictionaryButton
        navigationItem.rightBarButtonItem = addButton
        
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        // Register cell
        tableView.register(UserCell.self, forCellReuseIdentifier: Keys.userCell)
        
        floatingButton.addTarget(self, action: #selector(showAddWordBottomSheet), for: .touchUpInside)
        
        viewModel.loadWords()
        viewModel.groupWords()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: Keys.userCell, for: indexPath) as! UserCell
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
            
            commonMethods.showBottomSheet(self, bottomSheet: editBottomSheet)
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
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height) {
            floatingButton.isHidden = true
        } else {
            floatingButton.isHidden = false
        }
    }
    
    @objc private func showAddWordBottomSheet() {
        let addWordBottomSheet = AddWordBottomSheet()
        addWordBottomSheet.delegate = self
        commonMethods.showBottomSheet(self, bottomSheet: addWordBottomSheet)
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
