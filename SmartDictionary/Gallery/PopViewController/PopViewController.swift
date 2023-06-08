//
//  PopViewController.swift
//  SmartDictionary
//
//  Created by Александра Кострова on 05.06.2023.
//

import UIKit

final class PopViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private let viewModel = PopViewModel()
    private let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.setViewController(self)

        imagePicker.delegate = self
        tableView.register(PopCell.self, forCellReuseIdentifier: CellNames.popCell)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellNames.popCell, for: indexPath) as! PopCell
        
        cell.cellTitle.text = "\(PopCellModel.buttonNames[indexPath.row])"
        
        return cell
    }
    
    // MARK: - Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.row {
        case 0:
            viewModel.openGalleryButtonTapped(self)
        case 1:
            viewModel.openCameraButtonTapped(self)
        case 2:
            viewModel.openSearchViewController(self)
        default:
            print("Cell error")
        }
    }
}
