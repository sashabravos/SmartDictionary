//
//  DictionaryViewModel.swift
//  SmartDictionary
//
//  Created by Александра Кострова on 05.06.2023.
//

import UIKit

final class DictionaryViewModel {
    
    weak var viewController: DictionaryViewController?
    
    var dictionaryManager = DictionaryManager()

    private let englishWords = WordBase().wordsArray
    
    var dictionaryItems: [DictionaryModel] = []
    var filteredDictionaryItems: [DictionaryModel] = []
    
    var sections: [String] = []
    var sectionDictionary: [String: [DictionaryModel]] = [:]
    
    func setViewController(_ viewController: DictionaryViewController) {
        self.viewController = viewController
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
        viewController?.tableView.reloadData()
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
}
