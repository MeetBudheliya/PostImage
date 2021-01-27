//
//  ViewController.swift
//  GetPostData
//
//  Created by MAC on 21/12/20.
//

import UIKit

import Alamofire
class LoginVC: UIViewController {

    @IBOutlet weak var warningLBL: UILabel!
    @IBOutlet weak var mobileTXT: UITextField!
    @IBOutlet weak var PasswordTXT: UITextField!
    @IBOutlet weak var btn: UIButton!
    var storedToken = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        btn.layer.cornerRadius = 15
        
    }
   
    @IBAction func loginClicked(_ sender: UIButton) {
        
        guard let mobile = mobileTXT.text else {
            warningLBL.text = "Enter Mobile Number"
            return
        }
        guard let password = PasswordTXT.text else {
            warningLBL.text = "Enter Valid Password"
            return
        }
        let parameter:Parameters = [
            "phone":mobile,
            "password":password
        ]
        AF.request("https://adsumoriginator.com/apidemo/api/login", method: .post, parameters: parameter, encoding:JSONEncoding.default).response{responce in
            print(responce.data)
            
            switch responce.result{
            case .success(let dataa):
                do{
                    
                }catch let error as NSError{
                    print("Failed To Load :\(error.localizedDescription)")
                }
            case .failure(_):
                let alert:UIAlertController = UIAlertController(title: "Message", message: "Enter Right ID Password", preferredStyle: .alert)
                alert.addAction((uialert)
            }
        }
        
    }
    @IBAction func RegisterAsUser(_ sender: UIButton) {
        let VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RegisterVC") as! RegisterVC
        self.navigationController?.pushViewController(VC, animated: true)
    }
}

