//
//  UserDictionaryView.swift
//  SmartDictionary
//
//  Created by Александра Кострова on 03.06.2023.
//

import UIKit
import CoreData

final class UserDictionaryViewModel {
    
    weak var viewController: UserDictionaryViewController?
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private let request: NSFetchRequest<UserWord> = UserWord.fetchRequest()
    
    lazy var wordsDatabaseInfo = [UserWord]()
    lazy var wordDictionary: [String: [String]] = [:]
    
    lazy var words = wordsDatabaseInfo.compactMap { $0.text }
    lazy var sectionKey = Array(wordDictionary.keys.sorted())
    
    // MARK: - Model Manipulation Methods
    
    func setViewController(_ viewController: UserDictionaryViewController) {
        self.viewController = viewController
    }
    
    func loadWords() {
        do {
            wordsDatabaseInfo = try context.fetch(request)
        } catch {
            print("Error loading categories \(error)")
        }
        viewController?.tableView.reloadData()
    }
    
    func groupWords() {
        wordDictionary = fillWordDictionary(from: wordsDatabaseInfo)
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "SectionUpdated"),
                                               object: nil, queue: nil) { [weak viewController] notification in
            if let sectionKey = notification.object as? String {
                if let sectionIndex = self.sectionKey.firstIndex(of: sectionKey) {
                    if let wordCount = self.wordDictionary[sectionKey]?.count, wordCount == 0 {
                        self.wordDictionary.removeValue(forKey: sectionKey)
                        viewController?.tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
                    } else {
                        self.updateSectionState(sectionKey: sectionKey)
                    }
                }
            }
        }
        
        viewController?.tableView.reloadData()
    }
    
    func updateSectionState(sectionKey: String) {
        if let sectionIndex = Array(wordDictionary.keys.sorted()).firstIndex(of: sectionKey) {
            viewController?.tableView.reloadSections(IndexSet(integer: sectionIndex), with: .none)
        }
    }
    
 // MARK: - Create/filter/changed/delete the words
    
    func addNewWord(_ word: UserWord) {
        wordsDatabaseInfo.append(word)
        groupWords()
    }
    
    func changeWord(_ word: UserWord) {
        if let wordText = word.text, let index = words.firstIndex(of: wordText) {
            wordsDatabaseInfo[index] = word
            groupWords()
        }
    }
    
    func filterWords(for searchText: String?) {
        guard let searchText = searchText, !searchText.isEmpty else {
            wordDictionary = fillWordDictionary(from: wordsDatabaseInfo)
            return
        }
        
        let filteredWords = wordsDatabaseInfo.filter { $0.text?.localizedCaseInsensitiveContains(searchText) == true }
        wordDictionary = fillWordDictionary(from: filteredWords)
    }
    
    func deleteWord(at indexPath: IndexPath) {
        let sectionKey = sectionKey[indexPath.section]
        guard let word = wordDictionary[sectionKey]?[indexPath.row] else {
            return
        }

        if let userWord = wordsDatabaseInfo.first(where: { $0.text == word }) {
            context.delete(userWord)
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            wordsDatabaseInfo.remove(at: indexPath.row)
        }

       wordDictionary[sectionKey]?.remove(at: indexPath.row)
        if wordDictionary[sectionKey]?.isEmpty == true {
            wordDictionary.removeValue(forKey: sectionKey)
            viewController?.tableView.deleteSections(IndexSet(integer: indexPath.section), with: .fade)
        } else {
            viewController?.tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func fillWordDictionary(from words: [UserWord]) -> [String: [String]] {
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
}
