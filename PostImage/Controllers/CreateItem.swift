//
//  ViewController.swift
//  PostImage
//
//  Created by MAC on 27/01/21.
//

import UIKit
import BSImagePicker
import Photos
class CreateItem: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    let selectImageBTn = UIButton()
    let UploadImageBTN = UIButton()
    let image = UIImageView()
    let titl = UITextField()
    let desc = UITextField()
    private var selectedImages: [UIImage] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        AddImageView()
        Addselectbutton()
        AddUploadImagebutton()
        AddtextFields()
    }
    
    func AddtextFields() {
        self.view.addSubview(desc)
        desc.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([desc.centerXAnchor.constraint(equalTo: view.centerXAnchor),desc.bottomAnchor.constraint(equalTo: selectImageBTn.topAnchor,constant: -20),desc.heightAnchor.constraint(equalToConstant: 40),desc.widthAnchor.constraint(equalToConstant: 250)])
        desc.placeholder = "Enter Description"
        
        self.view.addSubview(titl)
        titl.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([titl.centerXAnchor.constraint(equalTo: view.centerXAnchor),titl.bottomAnchor.constraint(equalTo: desc.topAnchor,constant: -20),titl.heightAnchor.constraint(equalToConstant: 40),titl.widthAnchor.constraint(equalToConstant: 250)])
        titl.placeholder = "Enter Title"
    }
    
    func Addselectbutton(){
        self.view.addSubview(selectImageBTn)
        selectImageBTn.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([selectImageBTn.centerXAnchor.constraint(equalTo: view.centerXAnchor),selectImageBTn.bottomAnchor.constraint(equalTo: image.topAnchor,constant: -20),selectImageBTn.heightAnchor.constraint(equalToConstant: 35),selectImageBTn.widthAnchor.constraint(equalToConstant: 150)])
        selectImageBTn.setTitle("Select Image", for: .normal)
        selectImageBTn.setTitleColor(.white, for: .normal)
        selectImageBTn.backgroundColor = .gray
        selectImageBTn.layer.cornerRadius = 15
        selectImageBTn.contentHorizontalAlignment = .center
        selectImageBTn.addTarget(self, action: #selector(SelectImageeClicked), for: .touchUpInside)
    }
    @objc func SelectImageeClicked(){
        print("Select Image Clicked")
       
        let imagePicker = ImagePickerController()

        presentImagePicker(imagePicker, select: { (asset) in
            // User selected an asset. Do something with it. Perhaps begin processing/upload?
        }, deselect: { (asset) in
            // User deselected an asset. Cancel whatever you did when asset was selected.
        }, cancel: { (assets) in
            // User canceled selection.
        }, finish: { (assets) in
            self.selectedImages = []
            let options: PHImageRequestOptions = PHImageRequestOptions()
            options.deliveryMode = .highQualityFormat
 
            for asset in assets {
                PHImageManager.default().requestImage(for: asset, targetSize: PHImageManagerMaximumSize, contentMode: .aspectFit, options: options) { (image, info) in
                    
                    self.selectedImages.append(image!)
                    //Add Collection instead of image
                }
            }
        })
    }
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let ChoosedImage = info[.originalImage] as! UIImage
        image.image = ChoosedImage
        dismiss(animated: true, completion: nil)
    }
    
    
    func AddImageView(){
        self.view.addSubview(image)
        image.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([image.centerXAnchor.constraint(equalTo: view.centerXAnchor),image.centerYAnchor.constraint(equalTo: view.centerYAnchor,constant: 100),image.heightAnchor.constraint(equalToConstant: 250),image.widthAnchor.constraint(equalToConstant: 250)])
        image.contentMode = .scaleToFill
        image.clipsToBounds = true
        image.image = #imageLiteral(resourceName: "1")
    }
    
    
    func AddUploadImagebutton(){
        self.view.addSubview(UploadImageBTN)
        UploadImageBTN.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([UploadImageBTN.centerXAnchor.constraint(equalTo: view.centerXAnchor),UploadImageBTN.topAnchor.constraint(equalTo: image.bottomAnchor,constant: 20),UploadImageBTN.heightAnchor.constraint(equalToConstant: 35),UploadImageBTN.widthAnchor.constraint(equalToConstant: 150)])
        UploadImageBTN.setTitle("Upload Image", for: .normal)
        UploadImageBTN.setTitleColor(.white, for: .normal)
        UploadImageBTN.backgroundColor = .green
        UploadImageBTN.layer.cornerRadius = 15
        UploadImageBTN.contentHorizontalAlignment = .center
        UploadImageBTN.addTarget(self, action: #selector(uploadImageToServer), for: .touchUpInside)
    }
    @objc func uploadImageToServer(){
        let imageData:Data = (image.image?.pngData())!
        let imageString:String = imageData.base64EncodedString()
        let alert = UIAlertController(title: "Loading", message: "Please Wait...", preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
        let urlString = "ImageString = \(imageString)"
       
        var request = URLRequest(url: URL(string: "https://static.toiimg.com/photo/72975551.cms")!)
        request.setValue("application/x-www-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = urlString.data(using: .utf8)
        NSURLConnection.sendAsynchronousRequest(request, queue: .main) { (Response, Data, Error) in
            guard let data = Data else{
                return
            }
            let responseString = String(data: data, encoding: .utf8) as! String
                alert.dismiss(animated: true) {
                let messageAlert = UIAlertController(title: "Sucess", message: responseString, preferredStyle: .alert)
                messageAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action:UIAlertAction) in
                    //
                }))
                self.present(messageAlert, animated: true, completion: nil)
            }
        }
    }

}

