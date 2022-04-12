//
//  NewPointViewController.swift
//  FishingPoints
//
//  Created by Roman Torry on 29.03.22.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage
import Cosmos




class NewPointViewController: UITableViewController {
    
    var currentPoint: Point?
    var currentRating = 0.0
    
    var newPoint: Point!
    var user: Users!
    var ref: DatabaseReference!
    var imageIsChange = false
    
    @IBOutlet weak var imageOfPoint: UIImageView!
    @IBOutlet weak var pointName: UITextField!
    @IBOutlet weak var coordinatesTF: UITextField!
    @IBOutlet weak var pointType: UIPickerView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var cosmosView: CosmosView!
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        saveButton.isEnabled = false
        
        pointName.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        
        guard let currentUser = Auth.auth().currentUser else { return }
        user = Users(user: currentUser)
        ref = Database.database(url: "https://fishingpoints-e0f7c-default-rtdb.firebaseio.com/").reference(withPath: "users").child(user.uid).child("points")
        
        setupEditScreen()
        
        cosmosView.didTouchCosmos = { rating in
            self.currentRating = rating
        }
        
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
    
    //MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let identifier = segue.identifier, let mapVC = segue.destination as? MapViewController else { return }
        
        mapVC.incomeSegueIdentifier = identifier
        mapVC.mapVCDelegate = self
        
        if identifier == "showMap" {
            mapVC.point = currentPoint
        }
    }
    
    
    func saveNewPoint () {
        
        let image = imageIsChange ? imageOfPoint.image! :  #imageLiteral(resourceName: "Photo")
        newPoint = Point(name: pointName.text!, rating: currentRating, userID: user.uid, coordinates: coordinatesTF.text, imageOfPoint: codingImage(fromImage: image))
        
//        if currentPoint != nil {
//            currentPoint?.name = newPoint.name
//            currentPoint?.coordinates = newPoint.coordinates
//            currentPoint?.rating = newPoint.rating
//            currentPoint?.imageOfPoint = newPoint.imageOfPoint
//            currentPoint?.ref?.updateChildValues(["name": currentPoint?.name as Any, "coordinates": currentPoint?.coordinates as Any, "photo": currentPoint?.imageOfPoint as Any, "rating": currentPoint?.rating as Any])
//        } else {
//            let pointRef = ref?.child(newPoint.name)
//            pointRef?.setValue(newPoint.convertToDictionary())
//        }
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        dismiss(animated: true)
    }
    
    private func setupEditScreen () {
        if currentPoint != nil {
            setupNavigationBar()
            imageIsChange = true
            guard let imageString = currentPoint?.imageOfPoint, let image = UIImage(data: Data(base64Encoded: imageString, options: .ignoreUnknownCharacters)!) else { return }
            imageOfPoint.image = image
            imageOfPoint.contentMode = .scaleAspectFill
            pointName.text = currentPoint?.name
            coordinatesTF.text = currentPoint?.coordinates
            cosmosView.rating = currentPoint!.rating
        }
    }
    
    private func setupNavigationBar () {
        navigationItem.leftBarButtonItem = nil
        title = currentPoint?.name
        saveButton.isEnabled = true
    }
    
    private func codingImage(fromImage image: UIImage) -> String {
        let imageData = image.pngData()
        let base64string = imageData!.base64EncodedString(options: [.lineLength64Characters])
        
        return base64string
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
        
        imageIsChange = true
        dismiss(animated: true, completion: nil)
    }
}

extension NewPointViewController: MapViewControllerDelegate {
    func getCoordinates(_ coordinates: String?) {
        coordinatesTF.text = coordinates
    }
}
