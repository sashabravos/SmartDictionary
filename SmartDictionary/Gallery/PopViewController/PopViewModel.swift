//
//  PopViewModel.swift
//  SmartDictionary
//
//  Created by Александра Кострова on 06.06.2023.
//

import UIKit

final class PopViewModel {
    
    weak var viewController: PopViewController?
    
    func setViewController(_ viewController: PopViewController) {
        self.viewController = viewController
    }
    
    @objc func openGalleryButtonTapped(_ tableVC: UITableViewController) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        tableVC.present(imagePicker, animated: true, completion: nil)
    }
    
    @objc func openCameraButtonTapped(_ tableVC: UITableViewController) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        tableVC.present(imagePicker, animated: true, completion: nil)
    }
    
    @objc func openSearchViewController(_ tableVC: UITableViewController) {
        let searchVC = SearchViewController()
        
        let nav = UINavigationController(rootViewController: searchVC)
        nav.modalPresentationStyle = .pageSheet
        
        tableVC.present(nav, animated: true, completion: nil)
    }
}

//    // UIImagePickerControllerDelegate methods
//
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        if let selectedImage = info[.originalImage] as? UIImage {
//            // Обработка выбранного изображения
//        }
//        picker.dismiss(animated: true, completion: nil)
//    }
//
//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        picker.dismiss(animated: true, completion: nil)
//    }
