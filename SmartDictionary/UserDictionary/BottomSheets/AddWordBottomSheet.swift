//
//  AddWordBottomSheet.swift
//  SmartDictionary
//
//  Created by Александра Кострова on 26.05.2023.
//

import UIKit
import CoreData

protocol AddWordBottomSheetDelegate: AnyObject {
    func addWord(_ word: UserWord)
}

final class AddWordBottomSheet: UIViewController {
    
    weak var delegate: AddWordBottomSheetDelegate?
    
    private var userWord: UserWord?
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
    private lazy var titleLabel = bottomSheetTitleLabel("Add your new word")
    
    private lazy var newWordTextView = anyTextView("Enter new word")
    private lazy var translationTextView = anyTextView("Enter word's translation")
    private lazy var exampleTextView = anyTextView("Enter your example")
    
    private lazy var addButton: UIButton = {
        let button = bottomSheetBigButton(title: "ADD")
        button.addTarget(self, action: #selector(addWordToUserDictionary), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    private func setupViews() {
        
        view.backgroundColor = .white
                
        [titleLabel, newWordTextView, translationTextView, exampleTextView, addButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 25),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            newWordTextView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            newWordTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            newWordTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            newWordTextView.heightAnchor.constraint(equalToConstant: 56),
            
            translationTextView.topAnchor.constraint(equalTo: newWordTextView.bottomAnchor, constant: 16),
            translationTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            translationTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            translationTextView.heightAnchor.constraint(equalToConstant: 56),
            
            exampleTextView.topAnchor.constraint(equalTo: translationTextView.bottomAnchor, constant: 16),
            exampleTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            exampleTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            exampleTextView.heightAnchor.constraint(equalToConstant: 120),
            
            addButton.topAnchor.constraint(equalTo: exampleTextView.bottomAnchor, constant: 15),
            addButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            addButton.heightAnchor.constraint(equalToConstant: 56)
        ])
    }
    
    @objc private func addWordToUserDictionary() {
                
        guard let newWord = newWordTextView.text, !newWord.isEmpty else {
            return
        }
        
        let userWord = UserWord(context: context)
        userWord.text = newWord
        userWord.translation = translationTextView.text
        userWord.example = exampleTextView.text
        
        do {
            try context.save()
            delegate?.addWord(userWord)
            
            clearTextField()
            updatePlaceholderText()
            dismiss(animated: true, completion: nil)
        } catch {
            print("Failed to save word: \(error)")
        }
    }
    
    private func updatePlaceholderText() {
        newWordTextView.addPlaceholder(text: "Enter new word")
        translationTextView.addPlaceholder(text: "Enter word's translation")
        exampleTextView.addPlaceholder(text: "Enter your example")
    }
    
    private func clearTextField() {
        [newWordTextView, translationTextView, exampleTextView].forEach {
            $0.text = ""
        }
    }
}
