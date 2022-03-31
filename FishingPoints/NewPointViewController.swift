//
//  NewPointViewController.swift
//  FishingPoints
//
//  Created by Roman Torry on 29.03.22.
//

import UIKit

class NewPointViewController: UITableViewController {
    
    var newPoint: Point?
    
    @IBOutlet weak var imageOfPoint: UIImageView!
    @IBOutlet weak var pointName: UITextField!
    @IBOutlet weak var coordinatesTF: UITextField!
    @IBOutlet weak var pointType: UIPickerView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        saveButton.isEnabled = false
        
        pointName.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        
    }

    
    //MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            //вызов меню для изображения
            let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            let cameraAction = UIAlertAction(title: "Camera", style: .default) { _ in
                self.chooseImagePicker(source: .camera)
            }
            let cameraIcon = UIImage(named: "cameraIP")
            cameraAction.setValue(cameraIcon, forKey: "image")
            cameraAction.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
            
            let photoAction = UIAlertAction(title: "Photo", style: .default) { _ in
                self.chooseImagePicker(source: .photoLibrary)
            }
            let photoIcon = UIImage(named: "photoIP")
            photoAction.setValue(photoIcon, forKey: "image")
            photoAction.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            
            
            
            actionSheet.addAction(cameraAction)
            actionSheet.addAction(photoAction)
            actionSheet.addAction(cancelAction)
            present(actionSheet, animated: true)
        } else {
            view.endEditing(true)
        }
    }
    
    func saveNewPoint () {
        
        newPoint = Point(name: pointName.text!, coordinate: coordinatesTF.text, typeOfPond: pointType.textInputContextIdentifier, imageOfPoint: imageOfPoint.image)
        
    }
    @IBAction func cancelAction(_ sender: Any) {
        dismiss(animated: true)
    }
    
}

extension NewPointViewController: UITextFieldDelegate {
    
    //hide keyboard by press done
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc private func textFieldChanged () {
        if pointName.text?.isEmpty == false {
            saveButton.isEnabled = true
        }
    }
    
}

//MARK: - Work with image

extension NewPointViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func chooseImagePicker (source: UIImagePickerController.SourceType) {
        
        if UIImagePickerController.isSourceTypeAvailable(source) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = source
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageOfPoint.image = info[.editedImage] as? UIImage
        imageOfPoint.contentMode = .scaleAspectFill
        imageOfPoint.clipsToBounds = true
        dismiss(animated: true, completion: nil)
    }
}
