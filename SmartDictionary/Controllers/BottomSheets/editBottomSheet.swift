//
//  EditBottomSheet.swift
//  SmartDictionary
//
//  Created by Александра Кострова on 28.05.2023.
//



import UIKit
import CoreData

class EditBottomSheet: UIViewController {
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var titleTest = String()
    
    private func anyTextView() -> UITextView {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 20)
        textView.textColor = .black
        textView.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1.0)
        textView.isEditable = true
        textView.isScrollEnabled = true
        textView.layer.cornerRadius = 10
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.textContainerInset = UIEdgeInsets(top: 15, left: 8, bottom: 4, right: 8)
        
        return textView
    }
    
    let titleLabel: UILabel = {
        let label = UILabel()
//        label.text = "Word"
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    lazy var newWordTextView = anyTextView()
    lazy var translationTextView = anyTextView()
    lazy var exampleTextView = anyTextView()
    
    private lazy var updateButton: UIButton = {
        let button = UIButton()
        button.setTitle("UPDATE", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(red: 0.31, green: 0.75, blue: 0.63, alpha: 1.0)
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(updateWordInfo), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
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
            updateButton.heightAnchor.constraint(equalToConstant: 56),
        ])
    }
    
    func getWordInfo(text: String) -> String {
        let wordInfo = WordInfo(text: text)
        titleTest = wordInfo.text
        print("getWord \(text)")
        return titleTest

//        titleLabel.text = cellTitle
//        newWordTextField.text = cellTitle
//        translationTextField.text = cellTitleTranslation
//        exampleTextView.text = cellTitleExample
    }
    
    @objc private func updateWordInfo() {
        dismiss(animated: true, completion: nil)
    }
}
