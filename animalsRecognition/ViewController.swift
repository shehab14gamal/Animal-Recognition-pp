//
//  ViewController.swift
//  animalsRecognition
//
//  Created by shehab on 10/4/19.
//  Copyright © 2019 shehab. All rights reserved.
//

import UIKit
import CoreML
import Vision
import Social

class ViewController: UIViewController, UINavigationControllerDelegate , UIImagePickerControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
    }
    
    
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        
        if  let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
        
        imageView.image = pickedImage
            
            
            guard let ciImage = CIImage(image : pickedImage) else{
            fatalError("failed to convert into ciImage")
            }
            
            
            detect(image: ciImage)
            
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
        
        
    }

    func detect(image : CIImage)  {
        guard let model = try? VNCoreMLModel(for: ImageClassifier().model)else {
            fatalError("failed to create model")
        }
        
        
        
            let request = VNCoreMLRequest(model: model) { (request, error) in
                guard   let result = request.results as? [VNClassificationObservation]else{
                    fatalError("failed to get results")
                }
                
                
                if let firstResult = result.first{
                    if firstResult.identifier.contains("nose"){
                        self.navigationItem.title = "nose"
                        self.navigationController?.navigationBar.barTintColor = UIColor.green
                        self.navigationController?.navigationBar.isTranslucent = false
                    }else if firstResult.identifier.contains("eye"){
                        self.navigationItem.title = "eye"
                        self.navigationController?.navigationBar.barTintColor = UIColor.green
                        self.navigationController?.navigationBar.isTranslucent = false
                    }else if firstResult.identifier.contains("ear"){
                        self.navigationItem.title = "ear"
                        self.navigationController?.navigationBar.barTintColor = UIColor.green
                        self.navigationController?.navigationBar.isTranslucent = false
                    }else{
                        self.navigationItem.title = "Unrecognizable"
                        self.navigationController?.navigationBar.barTintColor = UIColor.red
                        self.navigationController?.navigationBar.isTranslucent = false
                    }
                    
                    
                }
                
        }
        
        let handler = VNImageRequestHandler(ciImage : image)
        try! handler.perform([request])
        
    }
    
    
    
    
    
    
    
    
    @IBAction func cameraButtonTapped(_ sender: UIBarButtonItem) {
        present(imagePicker, animated: true, completion: nil)
    }
    
}

