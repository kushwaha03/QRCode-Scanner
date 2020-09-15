//
//  ViewController.swift
//  QRCode Scanner
//
//  Created by Krishna Kushwaha on 15/09/20.
//  Copyright © 2020 Krishna Kushwaha. All rights reserved.
//

import UIKit
import AVFoundation
class ViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        let photoTap = UITapGestureRecognizer(target: self, action: #selector(promptPhoto))
        self.view.addGestureRecognizer(photoTap)
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
           super.viewDidAppear(animated)
           
           if imageView.image == nil {
               promptPhoto()
           }
       }
       
       @objc
       func promptPhoto() {
           
           let prompt = UIAlertController(title: "Choose a Photo",
                                          message: "Please choose a photo.",
                                          preferredStyle: .actionSheet)
           
           let imagePicker = UIImagePickerController()
           imagePicker.delegate = self
           
           func presentCamera(_ _: UIAlertAction) {
               imagePicker.sourceType = .camera
               self.present(imagePicker, animated: true)
           }
           
           let cameraAction = UIAlertAction(title: "Camera",
                                            style: .default,
                                            handler: presentCamera)
           
           func presentLibrary(_ _: UIAlertAction) {
               imagePicker.sourceType = .photoLibrary
               self.present(imagePicker, animated: true)
           }
           
           let libraryAction = UIAlertAction(title: "Photo Library",
                                             style: .default,
                                             handler: presentLibrary)
           
           func presentAlbums(_ _: UIAlertAction) {
               imagePicker.sourceType = .savedPhotosAlbum
               self.present(imagePicker, animated: true)
           }
           
           let albumsAction = UIAlertAction(title: "Saved Albums",
                                            style: .default,
                                            handler: presentAlbums)
           
           let cancelAction = UIAlertAction(title: "Cancel",
                                            style: .cancel,
                                            handler: nil)
           
           prompt.addAction(cameraAction)
           prompt.addAction(libraryAction)
           prompt.addAction(albumsAction)
           prompt.addAction(cancelAction)
           
           self.present(prompt, animated: true, completion: nil)
       }
       

    // MARK: - UIImagePickerControllerDelegate
       
       func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
           // Dismiss picker, returning to original root viewController.
           dismiss(animated: true, completion: nil)
       }

       func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
       {
        if let qrcodeImg = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                 let detector:CIDetector=CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: [CIDetectorAccuracy:CIDetectorAccuracyHigh])!
                 let ciImage:CIImage=CIImage(image:qrcodeImg)!
                 var qrCodeLink=""
       
                 let features=detector.features(in: ciImage)
                 for feature in features as! [CIQRCodeFeature] {
                     qrCodeLink += feature.messageString!
                 }
                 
                 if qrCodeLink=="" {
                     print("nothing")
                    let ac = UIAlertController(title: "Sorry ", message: "this QRCode are not supported!", preferredStyle: .alert)
                                ac.addAction(UIAlertAction(title: "OK", style: .default))
                                present(ac, animated: true)
                    
                 }else{
                     print("message: \(qrCodeLink)")
                    
                    let ac = UIAlertController(title: "Well Done", message: "Your QRCode are supported!", preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default))
                    present(ac, animated: true)
                 }
             }
             else{
                print("Something went wrong")
             }
            self.dismiss(animated: true, completion: nil)
           }
       
    
}

