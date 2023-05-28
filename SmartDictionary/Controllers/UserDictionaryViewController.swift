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
    
    var words: [String] = []
    var filteredWords: [String] = []
    var sections: [String] = []
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
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Keys.userCell)
        
        loadWords()
        groupWords()
    }
    
    // MARK: - Model Manipulation Methods
    
    func groupWords() {
        
        // grouping words by first letter
        for word in words {
            let firstLetter = String(word.prefix(1)).uppercased()
            if var wordGroup = wordDictionary[firstLetter] {
                wordGroup.append(word)
                wordDictionary[firstLetter] = wordGroup
            } else {
                wordDictionary[firstLetter] = [word]
            }
        }
        
        sections = wordDictionary.keys.sorted()
        
        tableView.reloadData()
        
    }
    
    func loadWords() {
        do {
            wordsArray = try context.fetch(request)
            
            // Очищаем массив words перед загрузкой новых слов
            words.removeAll()
            
            // Заполняем массив words значениями из базы данных
            for word in wordsArray {
                if let wordText = word.text {
                    words.append(wordText)
                }
            }
            
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
            return sections.count
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if isSearchActive() {
            return nil
        } else {
            return sections[section]
        }
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        if isSearchActive() {
            return nil
        } else {
            return sections
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearchActive() {
            return filteredWords.count
        } else {
            let sectionKey = sections[section]
            return wordDictionary[sectionKey]?.count ?? 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Keys.userCell, for: indexPath)
        let word: String
        if isSearchActive() {
            word = filteredWords[indexPath.row]
        } else {
            let sectionKey = sections[indexPath.section]
            word = wordDictionary[sectionKey]![indexPath.row]
        }
        
        cell.textLabel?.text = word
        
        return cell
    }
    
    // MARK: - Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let editBottomSheet = EditBottomSheet()
        if let cell = tableView.cellForRow(at: indexPath) {
            let title = cell.textLabel?.text ?? "No word"
            editBottomSheet.titleLabel.text = title
            editBottomSheet.newWordTextField.text = title
        }
        
        Templates().showBottomSheet(self, bottomSheet: editBottomSheet)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - UISearchBarDelegate
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterWords(for: searchText)
        tableView.reloadData()
    }
    
    func filterWords(for searchText: String?) {
        filteredWords = words.filter { word in
            if let searchText = searchText {
                return word.lowercased().contains(searchText.lowercased())
            }
            return false
        }
    }
    
    func isSearchActive() -> Bool {
        return searchController.isActive && !isSearchBarEmpty()
    }
    
    func isSearchBarEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
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
