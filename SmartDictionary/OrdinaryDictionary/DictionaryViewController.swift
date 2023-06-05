//
//  DictionaryViewController.swift
//  SmartDictionary
//
//  Created by Александра Кострова on 16.05.2023.
//

import UIKit

final class DictionaryViewController: UITableViewController {
    
    private let viewModel = DictionaryViewModel()

    private let commonMethods = CommonMethods()
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.setViewController(self)
        
        view.backgroundColor = .white
        
        navigationController?.navigationBar.barTintColor = UIColor(named: Colors.lightKhaki)
        
        // delegate
        viewModel.dictionaryManager.delegate = self
        
        // setup navigationBar items
        title = "Dictionary"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search"
        tableView.tableHeaderView = searchController.searchBar
        
        // register cell
        tableView.register(DictionaryCell.self, forCellReuseIdentifier: Keys.dictionaryCell)
        
        viewModel.loadDataFromAPI()
        
    }
    
    // MARK: - Table View Data Source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionTitle = viewModel.sections[section]
        return viewModel.sectionDictionary[sectionTitle]?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Keys.dictionaryCell, for: indexPath) as! DictionaryCell
        let sectionTitle = viewModel.sections[indexPath.section]
        let dictionaryItem = viewModel.sectionDictionary[sectionTitle]?[indexPath.row]
        
        cell.addButton.addTarget(self, action: #selector(addToUserDictionary), for: .touchUpInside)
        
        cell.configure(with: dictionaryItem!)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.sections[section]
    }
    
    // MARK: - Button Action
    
    @objc private func addToUserDictionary() {
        commonMethods.showBottomSheet(self, bottomSheet: AddWordBottomSheet())
    }
}

// MARK: - UISearchBarDelegate

extension DictionaryViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.filterWords(for: searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.filterWords(for: nil)
    }
}

// MARK: - DictionaryManagerDelegate

extension DictionaryViewController: DictionaryManagerDelegate {
    func didUpdateData(_ dictionaryManager: DictionaryManager, dictionary: DictionaryModel) {
        DispatchQueue.main.async {
            self.viewModel.dictionaryItems.append(dictionary)
            self.viewModel.filterWords(for: self.searchController.searchBar.text)
        }
    }
    
    func didFailWithError(error: Error) {
        print("Error loading data: \(error)")
    }
}
