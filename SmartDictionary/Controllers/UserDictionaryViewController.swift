//
//  ViewController.swift
//  SmartDictionary
//
//  Created by Александра Кострова on 15.05.2023.
//


import UIKit
import CoreData

class UserDictionaryViewController: UITableViewController, UISearchBarDelegate {
        
    private var wordsArray = [UserWord]()
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private let request: NSFetchRequest <UserWord> = UserWord.fetchRequest()
    
    var wordDictionary: [String: [String]] = [:]
        
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "Search"
        return searchController
    }()
    
    private lazy var addButton: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showAddWordBottomSheet))
        button.tintColor = .label
        return button
    }()
    
    private lazy var dictionaryButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Dictionary", style: .plain, target: self, action: #selector(goToDictionary))
        button.tintColor = .label
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setup navigationBar items
        title = "Your words 😜"
        navigationController?.navigationBar.prefersLargeTitles = true

        navigationItem.leftBarButtonItem = dictionaryButton
        navigationItem.rightBarButtonItem = addButton
        
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        // register cell
        tableView.register(UserCell.self , forCellReuseIdentifier: Keys.userCell)
        
        loadWords()
        groupWords()
    }
    
    // MARK: - Model Manipulation Methods
    
    func groupWords() {
        
        // grouping words by first letter
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
        
        tableView.reloadData()
    }
    
    func loadWords() {
        do {
            wordsArray = try context.fetch(request)
        } catch {
            print("Error loading categories \(error)")
        }

        tableView.reloadData()
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
    
    // MARK: - Button Actions
    
    @objc private func showAddWordBottomSheet() {
        Templates().showBottomSheet(self, bottomSheet: AddWordBottomSheet())
    }
    
    @objc func goToDictionary() {
        let dictionaryVC = DictionaryViewController()
        navigationController?.pushViewController(dictionaryVC, animated: true)
    }
}
