//
//  ViewController.swift
//  SmartDictionary
//
//  Created by Александра Кострова on 15.05.2023.
//

import UIKit
import CoreData

final class UserDictionaryViewController: UITableViewController, UISearchBarDelegate {
    
    // MARK: - Properties
    
    private let editBottomSheet = EditBottomSheet()
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private let request: NSFetchRequest<UserWord> = UserWord.fetchRequest()

    private var words: [String] = []
    private var wordsArray = [UserWord]()
    private var wordDictionary: [String: [String]] = [:]

    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "Search"
        return searchController
    }()
    
    private lazy var floatingButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "buttonIcon"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
            if let window = UIApplication.shared.windows.first {
                window.addSubview(button)
                NSLayoutConstraint.activate([
                    button.trailingAnchor.constraint(equalTo: window.safeAreaLayoutGuide.trailingAnchor, constant: -26),
                    button.bottomAnchor.constraint(equalTo: window.safeAreaLayoutGuide.bottomAnchor, constant: -16),
                    button.widthAnchor.constraint(equalToConstant: 65),
                    button.heightAnchor.constraint(equalToConstant: 65)
                ])
            }
        return button
    }()
    
    // MARK: - Bar Button Items
    
    private lazy var addButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Gallery", style: .plain, target: self,
                                     action: #selector(showAddWordBottomSheet))
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
        
        // Setup navigationBar items
        title = "Your words 😜"
        navigationController?.navigationBar.prefersLargeTitles = true

        navigationItem.leftBarButtonItem = dictionaryButton
        navigationItem.rightBarButtonItem = addButton
        
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        editBottomSheet.delegate = self
        
        // Register cell
        tableView.register(UserCell.self, forCellReuseIdentifier: Keys.userCell)
        
        floatingButton.addTarget(self, action: #selector(showAddWordBottomSheet), for: .touchUpInside)
        
        loadWords()
        groupWords()
    }
    
    // MARK: - Model Manipulation Methods
    
    func loadWords() {
        do {
            wordsArray = try context.fetch(request)
            words = wordsArray.compactMap { $0.text }
        } catch {
            print("Error loading categories \(error)")
        }

        tableView.reloadData()
    }

    func groupWords() {
        // Grouping words by first letter
        for word in wordsArray {
            if let wordText = word.text {
                let firstLetter = String(wordText.prefix(1)).uppercased()
                if var wordGroup = wordDictionary[firstLetter] {
                    wordGroup.append(wordText)
                    wordDictionary[firstLetter] = wordGroup
                } else {
                    wordDictionary[firstLetter] = [wordText]
                }
            }
        }
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "SectionUpdated"),
                                               object: nil, queue: nil) { [weak self] notification in
            if let sectionKey = notification.object as? String {
                if let sectionIndex = Array(self?.wordDictionary.keys.sorted() ?? []).firstIndex(of: sectionKey) {
                    if let wordCount = self?.wordDictionary[sectionKey]?.count, wordCount == 0 {
                        self?.wordDictionary.removeValue(forKey: sectionKey)
                        self?.tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
                    } else {
                        self?.updateSectionState(sectionKey: sectionKey)
                    }
                }
            }
        }
        
        tableView.reloadData()
    }
    
    func updateSectionState(sectionKey: String) {
        if let sectionIndex = Array(wordDictionary.keys.sorted()).firstIndex(of: sectionKey) {
            tableView.reloadSections(IndexSet(integer: sectionIndex), with: .none)
        }
    }
    
    // MARK: - UITableView DataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if isSearchActive() {
            return 1
        } else {
            return wordDictionary.count
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if isSearchActive() {
            return nil
        } else {
            let sectionKey = Array(wordDictionary.keys.sorted())[section]
            return sectionKey
        }
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        if isSearchActive() {
            return nil
        } else {
            return Array(wordDictionary.keys.sorted())
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearchActive() {
            return wordDictionary.values.flatMap({ $0 }).count
        } else {
            let sectionKey = Array(wordDictionary.keys.sorted())[section]
            return wordDictionary[sectionKey]?.count ?? 0
        }
    }
    
    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCell.EditingStyle,
                            forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteWord(at: indexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Keys.userCell, for: indexPath) as! UserCell
        let word: String
        if isSearchActive() {
            let allWords = wordDictionary.values.flatMap({ $0 })
            word = allWords[indexPath.row]
        } else {
            let sectionKey = Array(wordDictionary.keys.sorted())[indexPath.section]
            word = wordDictionary[sectionKey]![indexPath.row]
        }

        cell.textLabel?.text = word
        if let userWord = wordsArray.first(where: { $0.text == word }) {
            cell.configure(with: userWord)
        }

        // Delete button
        cell.showsDeleteButton = true
        cell.deleteButtonAction = { [weak self] in
            self?.deleteWord(at: indexPath)
        }
        
        return cell
    }

    // MARK: - Tableview Delegate Methods
        
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? UserCell {
            let editBottomSheet = EditBottomSheet()
            editBottomSheet.titleLabel.text = cell.cellTitle?.capitalized
            editBottomSheet.newWordTextView.text = cell.cellTitle
            editBottomSheet.translationTextView.text = cell.cellTitleTranslation
            editBottomSheet.exampleTextView.text = cell.cellTitleExample
            
            if let word = wordsArray.first(where: { $0.text == cell.cellTitle }) {
                editBottomSheet.userWord = word
            }
            
            Templates().showBottomSheet(self, bottomSheet: editBottomSheet)
        } else {
            print("Failed to get UserCell")
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - UISearchBarDelegate
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterWords(for: searchText)
        tableView.reloadData()
    }
    
    func filterWords(for searchText: String?) {
        guard let searchText = searchText, !searchText.isEmpty else {
            wordDictionary = loadAllWords()
            return
        }
        
        let filteredWords = wordsArray.filter { $0.text?.localizedCaseInsensitiveContains(searchText) == true }
        wordDictionary = createWordDictionary(from: filteredWords)
    }
    
    func isSearchActive() -> Bool {
        return searchController.isActive && !isSearchBarEmpty()
    }
    
    func isSearchBarEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func loadAllWords() -> [String: [String]] {
        var allWords: [String: [String]] = [:]
        
        for word in wordsArray {
            if let wordText = word.text {
                let firstLetter = String(wordText.prefix(1)).uppercased()
                if var wordGroup = allWords[firstLetter] {
                    wordGroup.append(wordText)
                    allWords[firstLetter] = wordGroup
                } else {
                    allWords[firstLetter] = [wordText]
                }
            }
        }
        
        return allWords
    }
    
    func createWordDictionary(from words: [UserWord]) -> [String: [String]] {
        var wordDictionary: [String: [String]] = [:]
        
        for word in words {
            if let wordText = word.text {
                let firstLetter = String(wordText.prefix(1)).uppercased()
                if var wordGroup = wordDictionary[firstLetter] {
                    wordGroup.append(wordText)
                    wordDictionary[firstLetter] = wordGroup
                } else {
                    wordDictionary[firstLetter] = [wordText]
                }
            }
        }
        
        return wordDictionary
    }
        
 // MARK: - Button's action
    
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
        Templates().showBottomSheet(self, bottomSheet: addWordBottomSheet)
    }
    
    func deleteWord(at indexPath: IndexPath) {
        let sectionKey = Array(wordDictionary.keys.sorted())[indexPath.section]
        guard let word = wordDictionary[sectionKey]?[indexPath.row] else {
            return
        }

        if let userWord = wordsArray.first(where: { $0.text == word }) {
            context.delete(userWord)
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            wordsArray.remove(at: indexPath.row)
        }

        wordDictionary[sectionKey]?.remove(at: indexPath.row)
        if wordDictionary[sectionKey]?.isEmpty == true {
            wordDictionary.removeValue(forKey: sectionKey)
            tableView.deleteSections(IndexSet(integer: indexPath.section), with: .fade)
        } else {
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    func groupNewWord(_ word: String) {
        let firstLetter = String(word.prefix(1)).uppercased()
        
        if var wordGroup = wordDictionary[firstLetter] {
            wordGroup.append(word)
            wordDictionary[firstLetter] = wordGroup
        } else {
            wordDictionary[firstLetter] = [word]
        }
        
        updateSectionState(sectionKey: firstLetter)
    }
    
    @objc private func goToDictionary() {
        let dictionaryViewController = DictionaryViewController()
        navigationController?.pushViewController(dictionaryViewController, animated: true)
    }
}

// MARK: - AddWordBottomSheetDelegate

extension UserDictionaryViewController: AddWordBottomSheetDelegate {
    func addWord(_ word: UserWord) {
        if let wordText = word.text {
            wordsArray.append(word)
            words.append(wordText)
            
            groupNewWord(wordText)
            
            tableView.reloadData()
        }
    }
}

// MARK: - EditBottomSheetDelegate

extension UserDictionaryViewController: EditBottomSheetDelegate {
    func updateWord(_ word: UserWord) {
        if let wordText = word.text, let index = words.firstIndex(of: wordText) {
            wordsArray[index] = word
            groupWords()
        }
    }
}
