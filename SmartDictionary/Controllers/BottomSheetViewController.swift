//
//  BottomSheetViewController.swift
//  SmartDictionary
//
//  Created by Александра Кострова on 26.05.2023.
//

import UIKit
import CoreData

class BottomSheetViewController: UIViewController {
    
    //    var selectedCategory: Category? {
    //        didSet {
    //            loadSortedWords()
    //        }
    //    }
    
    //    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    //    private let request: NSFetchRequest <Word> = Word.fetchRequest()
    //
    private func anyTextView(_ placeholder: String) -> UITextView {
        let textView = UITextView()
        textView.addPlaceholder(text: placeholder)
        textView.font = UIFont.systemFont(ofSize: 20)
        textView.textColor = .black
        textView.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1.0)
        textView.isEditable = true
        textView.isScrollEnabled = false
        textView.layer.cornerRadius = 10
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        
        return textView
    }

    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Add your new word"
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()

    private lazy var newWordTextField = anyTextView("Enter new word")
    private lazy var translationTextField = anyTextView("Enter word's translation")
    private lazy var exampleTextView = anyTextView("Enter your example")
    
    private lazy var addButton: UIButton = {
        let button = UIButton()
        button.setTitle("ADD", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(red: 0.31, green: 0.75, blue: 0.63, alpha: 1.0)
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(addWordToUserDictionary), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    private func setupViews() {
        
        view.backgroundColor = .white
        
        [titleLabel, newWordTextField, translationTextField, exampleTextView, addButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 25),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            newWordTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            newWordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            newWordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            newWordTextField.heightAnchor.constraint(equalToConstant: 56),
            
            translationTextField.topAnchor.constraint(equalTo: newWordTextField.bottomAnchor, constant: 16),
            translationTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            translationTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            translationTextField.heightAnchor.constraint(equalToConstant: 56),
            
            exampleTextView.topAnchor.constraint(equalTo: translationTextField.bottomAnchor, constant: 16),
            exampleTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            exampleTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            exampleTextView.heightAnchor.constraint(equalToConstant: 120),
            
            addButton.topAnchor.constraint(equalTo: exampleTextView.bottomAnchor, constant: 15),
            addButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            addButton.heightAnchor.constraint(equalToConstant: 56),
        ])
    }

    @objc private func addWordToUserDictionary() {
        // Get the input values from text fields
        let userVC = UserDictionaryViewController()
        print(userVC.words, userVC.filteredWords, userVC.sections, userVC.wordDictionary)
        
        let newWord = NewWordModel(text: newWordTextField.text ?? "", translation: translationTextField.text ?? "", example: exampleTextView.text ?? "")
        
        // Add newWord to your dictionary or perform any necessary actions
        
        dismiss(animated: true, completion: nil)
    }
}
