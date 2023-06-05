//
//  EditBottomSheet.swift
//  SmartDictionary
//
//  Created by Александра Кострова on 28.05.2023.
//

import UIKit
import CoreData

protocol EditBottomSheetDelegate: AnyObject {
    func updateWord(_ word: UserWord)
}

class EditBottomSheet: UIViewController {
    
    weak var delegate: EditBottomSheetDelegate?
    
    var userWord: UserWord?
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private var commonMethods = CommonMethods()
    
    lazy var titleLabel = commonMethods.bottomSheetTitleLabel("Add your new word")
    
    lazy var newWordTextView = commonMethods.anyTextView()
    lazy var translationTextView = commonMethods.anyTextView()
    lazy var exampleTextView = commonMethods.anyTextView()
    
    private lazy var updateButton: UIButton = {
        let button = commonMethods.bottomSheetBigButton(title: "UPDATE")
        button.addTarget(self, action: #selector(updateButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        
        if let word = userWord {
            titleLabel.text = word.text
            translationTextView.text = word.translation
            exampleTextView.text = word.example
        }
    }
    
    private func setupViews() {
        
        view.backgroundColor = .white
        
        [titleLabel, newWordTextView, translationTextView, exampleTextView, updateButton].forEach {
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
            
            updateButton.topAnchor.constraint(equalTo: exampleTextView.bottomAnchor, constant: 15),
            updateButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            updateButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            updateButton.heightAnchor.constraint(equalToConstant: 56)
        ])
    }
    
    @objc private func updateButtonTapped() {
        guard let word = userWord else { return }
        word.text = titleLabel.text
        word.translation = translationTextView.text
        word.example = exampleTextView.text

        delegate?.updateWord(word)
        
        do {
                try context.save() 
            } catch {
                print("Error saving context: \(error)")
            }
        
        dismiss(animated: true)
    }
}
