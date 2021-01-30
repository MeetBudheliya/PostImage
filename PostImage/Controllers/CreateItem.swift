//
//  ViewController.swift
//  PostImage
//
//  Created by MAC on 27/01/21.
//

import UIKit
import Alamofire
import BSImagePicker
import Photos
class CreateItem: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    let selectImageBTn = UIButton()
    let UploadImageBTN = UIButton()
 
    let titl = UITextField()
    let desc = UITextField()
    private var selectedImages: [UIImage] = []
    @IBOutlet weak var selecteddCollection: UICollectionView!
  
    override func viewDidLoad() {
        super.viewDidLoad()
        CollecctionSETUP()
        Addselectbutton()
        AddtextFields()
        AddUploadImagebutton()
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
        NSLayoutConstraint.activate([selectImageBTn.centerXAnchor.constraint(equalTo: view.centerXAnchor),selectImageBTn.bottomAnchor.constraint(equalTo: selecteddCollection.topAnchor,constant: -20),selectImageBTn.heightAnchor.constraint(equalToConstant: 35),selectImageBTn.widthAnchor.constraint(equalToConstant: 150)])
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
                    self.selecteddCollection.reloadData()
                }
            }
        })
    }
//    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        let ChoosedImages = info[.originalImage] as! [UIImage]
//        selectedImages = ChoosedImages
//        dismiss(animated: true, completion: nil)
//    }
    
    
    func CollecctionSETUP(){
        selecteddCollection.delegate = self
        selecteddCollection.dataSource = self
        selecteddCollection.register(UINib(nibName: "SelctedImg", bundle: nil), forCellWithReuseIdentifier: "SelctedImg")
       
    }
    
    
    func AddUploadImagebutton(){
        self.view.addSubview(UploadImageBTN)
        UploadImageBTN.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([UploadImageBTN.centerXAnchor.constraint(equalTo: view.centerXAnchor),UploadImageBTN.topAnchor.constraint(equalTo: selecteddCollection.bottomAnchor,constant: 20),UploadImageBTN.heightAnchor.constraint(equalToConstant: 35),UploadImageBTN.widthAnchor.constraint(equalToConstant: 150)])
        UploadImageBTN.setTitle("Upload Image", for: .normal)
        UploadImageBTN.setTitleColor(.white, for: .normal)
        UploadImageBTN.backgroundColor = .green
        UploadImageBTN.layer.cornerRadius = 15
        UploadImageBTN.contentHorizontalAlignment = .center
        UploadImageBTN.addTarget(self, action: #selector(uploadImageToServer), for: .touchUpInside)
    }
    @objc func uploadImageToServer(){
        let dataimage = selectedImages
        send_img(data_img: dataimage)
    }
    func send_img(data_img : [UIImage]?){
        let token = UserDefaults.standard.string(forKey: "stateSelected")
  
        let headers: HTTPHeaders = ["Authorization": "Bearer \(token!)","Content-type": "multipart/form-data"]
      
        let parameter:Parameters = ["title": titl.text!, "description": desc.text!]
       
        AF.upload(multipartFormData: { (multipartFormData) in
            print(multipartFormData)
            
            for data in data_img! {
                guard let imgData = data.jpegData(compressionQuality: 1) else { return }
                       
                multipartFormData.append(imgData, withName: "image[]", fileName: "image.jpeg", mimeType: "image/jpeg")
            }
            for (key, value) in parameter
            {
                multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
            }
        }, to:"https://adsumoriginator.com/apidemo/api/create_item", usingThreshold: UInt64.init(),method: .post, headers: headers).responseJSON
        {  (response) in
          
            switch response.result {
            case .success(let value) :
                //
                print("data sent success\(value)")
                self.titl.text = ""
                self.desc.text = ""
                self.selectedImages = []
                self.navigationController?.dismiss(animated: true, completion: nil)
                
            case .failure(let error):
                
                print(error)
            }
        }
    }

}
extension CreateItem:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SelctedImg", for: indexPath) as! SelctedImg
        cell.img.image = selectedImages[indexPath.row]
        return cell
    }
    
}
