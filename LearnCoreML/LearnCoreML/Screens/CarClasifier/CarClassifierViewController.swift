//
//  CarClassifierViewController.swift
//  LearnCoreML
//
//  Created by Andrii Halushka on 17.04.2021.
//

import UIKit
import PhotosUI
import Vision

class CarClassifierViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    private var carClassifier: CarClassifier?
    @IBOutlet var previewImageView: UIImageView!
    @IBOutlet var outputTextField: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CarClassifier.load { (result) in
            switch result {
            case .success(let model):
                self.carClassifier = model
            case .failure(let error):
                print(error)
            }
        }
    }
    
    @IBAction func uploadImageTapped(_ sender: Any) {
        let imgPicker = UIImagePickerController()
        imgPicker.sourceType = .photoLibrary
        imgPicker.delegate = self
        self.present(imgPicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else {
            return
        }
        
        previewImageView.image = image
        picker.dismiss(animated: true, completion: nil)
        
        if let cgImage = image.cgImage {
            do {
                let input = try CarClassifierInput(imageWith: cgImage)
                let result = try self.carClassifier!.prediction(input: input)
                
                let sortedLabelsProbs = result.classLabelProbs.sorted(by: { $0.key < $1.key })
                outputTextField.text = sortedLabelsProbs.reduce("") {
                    $0 + "\($1.key): \(Int($1.value * 100))%\n"
                }
            } catch let error {
                outputTextField.text = "Failed to process the image |\(error.localizedDescription)|"
            }
        } else {
            outputTextField.text = "Failed to get cgImage"
        }
    }
}
