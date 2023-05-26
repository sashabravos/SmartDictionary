//
//  DictionaryViewController.swift
//  SmartDictionary
//
//  Created by Александра Кострова on 16.05.2023.
//

import UIKit

class DictionaryViewController: UITableViewController {
    
    var dictionaryManager = DictionaryManager()
    let searchController = UISearchController(searchResultsController: nil)
    let englishWords = WordBase().sortedWordsArray
    var dictionaryItems: [DictionaryModel] = []
    var filteredDictionaryItems: [DictionaryModel] = []
    
    var wordDictionary: [String: [String]] = [:]
    var sections: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Dictionary"
        navigationController?.navigationBar.prefersLargeTitles = true
        tableView.register(DictionaryCell.self, forCellReuseIdentifier: "DictionaryCell")
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        tableView.tableHeaderView = searchController.searchBar
        
        dictionaryManager.delegate = self
        loadDataFromAPI()
    }
    
    func loadDataFromAPI() {
        for word in englishWords {
            dictionaryManager.getWordInfo(word: word)
        }
    }
    
    func filterWords(for searchText: String?) {
        if let searchText = searchText, !searchText.isEmpty {
            filteredDictionaryItems = dictionaryItems.filter { $0.currentWord.lowercased().contains(searchText.lowercased()) }
        } else {
            filteredDictionaryItems = dictionaryItems
        }
        groupWords()
        tableView.reloadData()
    }
    
    func groupWords() {
        wordDictionary.removeAll()
        
        for dictionaryItem in filteredDictionaryItems {
            let firstLetter = String(dictionaryItem.currentWord.prefix(1)).uppercased()
            if var wordGroup = wordDictionary[firstLetter] {
                wordGroup.append(dictionaryItem.currentWord)
                wordDictionary[firstLetter] = wordGroup
            } else {
                wordDictionary[firstLetter] = [dictionaryItem.currentWord]
            }
        }
        
        sections = wordDictionary.keys.sorted()
    }
    
    // MARK: - Table View Data Source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionTitle = sections[section]
        return wordDictionary[sectionTitle]?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DictionaryCell", for: indexPath) as! DictionaryCell
        let sectionTitle = sections[indexPath.section]
        let wordsInSection = wordDictionary[sectionTitle]
        let word = wordsInSection?[indexPath.row] ?? ""
        
        cell.wordLabel.text = word
        cell.transcriptionLabel.text = dictionaryItems.first { $0.currentWord == word }?.transcription
        cell.translationLabel.text = dictionaryItems.first { $0.currentWord == word }?.translation
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
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
