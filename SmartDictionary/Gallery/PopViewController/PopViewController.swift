//
//  PopViewController.swift
//  SmartDictionary
//
//  Created by Александра Кострова on 05.06.2023.
//

import UIKit

final class PopViewController: UITableViewController, UIPopoverPresentationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        PopViewController().modalPresentationStyle = .popover
        
        let popover = PopViewController().popoverPresentationController!
            popover.delegate = self
            popover.sourceView = self.view
            popover.sourceRect = CGRect(x: 0, y: 0, width: 100, height: 50)


        tableView.register(PopCell.self, forCellReuseIdentifier: Keys.popCell)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Keys.popCell, for: indexPath) as! PopCell
        
        cell.cellTitle.text = "\(PopCellModel.buttonNames[indexPath.row])"
        
        return cell
    }
    
    // MARK: - Tableview Delegate Methods
        
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}