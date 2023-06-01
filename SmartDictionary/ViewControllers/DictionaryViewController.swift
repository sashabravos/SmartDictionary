//
//  DictionaryViewController.swift
//  SmartDictionary
//
//  Created by Александра Кострова on 16.05.2023.
//

import UIKit

class DictionaryViewController: UITableViewController {
    
    var dictionaryManager = DictionaryManager()
    let englishWords = WordBase().wordsArray
    
    var dictionaryItems: [DictionaryModel] = []
    var filteredDictionaryItems: [DictionaryModel] = []
    
    var sections: [String] = []
    var sectionDictionary: [String: [DictionaryModel]] = [:]
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // delegate
        dictionaryManager.delegate = self
        
        // setup navigationBar items
        title = "Dictionary"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search"
        tableView.tableHeaderView = searchController.searchBar
        
        // register cell
        tableView.register(DictionaryCell.self, forCellReuseIdentifier: Keys.dictionaryCell)
        
        loadDataFromAPI()
        
    }
    
    func loadDataFromAPI() {
        for word in englishWords {
            dictionaryManager.getWordInfo(word: word)
        }
    }
    
    func filterWords(for searchText: String?) {
        if let searchText = searchText, !searchText.isEmpty {
            filteredDictionaryItems = dictionaryItems.filter {
                $0.currentWord.lowercased().contains(searchText.lowercased())
            }
        } else {
            filteredDictionaryItems = dictionaryItems
        }
        groupWords()
        tableView.reloadData()
    }
    
    func groupWords() {
        sectionDictionary.removeAll()
        
        for dictionaryItem in filteredDictionaryItems {
            let firstLetter = String(dictionaryItem.currentWord.prefix(1)).uppercased()
            if var sectionItems = sectionDictionary[firstLetter] {
                sectionItems.append(dictionaryItem)
                sectionDictionary[firstLetter] = sectionItems
            } else {
                sectionDictionary[firstLetter] = [dictionaryItem]
            }
        }
        
        sections = sectionDictionary.keys.sorted()
    }
    
    // MARK: - Table View Data Source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionTitle = sections[section]
        return sectionDictionary[sectionTitle]?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Keys.dictionaryCell, for: indexPath) as! DictionaryCell
        let sectionTitle = sections[indexPath.section]
        let dictionaryItem = sectionDictionary[sectionTitle]?[indexPath.row]
        
        cell.addButton.addTarget(self, action: #selector(addToUserDictionary), for: .touchUpInside)
        
        cell.configure(with: dictionaryItem!)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    // MARK: - Button Action
    
    @objc private func addToUserDictionary() {
        Templates().showBottomSheet(self, bottomSheet: AddWordBottomSheet())
    }
}

// MARK: - UISearchBarDelegate

extension DictionaryViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterWords(for: searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        filterWords(for: nil)
    }
}

// MARK: - DictionaryManagerDelegate

extension DictionaryViewController: DictionaryManagerDelegate {
    func didUpdateData(_ dictionaryManager: DictionaryManager, dictionary: DictionaryModel) {
        DispatchQueue.main.async {
            self.dictionaryItems.append(dictionary)
            self.filterWords(for: self.searchController.searchBar.text)
        }
    }
    
    func didFailWithError(error: Error) {
        print("Error loading data: \(error)")
    }
}
