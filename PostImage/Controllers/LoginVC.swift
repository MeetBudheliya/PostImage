//
//  ViewController.swift
//  GetPostData
//
//  Created by MAC on 21/12/20.
//

import UIKit

import Alamofire
class LoginVC: UIViewController,SendIdPassToLogin{
  
    func sendIdPassword(id: String, password: String) {
        self.regID = id
        self.regPass = password
    }

    @IBOutlet weak var warningLBL: UILabel!
    @IBOutlet weak var mobileTXT: UITextField!
    @IBOutlet weak var PasswordTXT: UITextField!
    var regID:String?
    var regPass:String?
    @IBOutlet weak var btn: UIButton!
    var storedToken = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        btn.layer.cornerRadius = 15
        mobileTXT.text = "123456788"
        PasswordTXT.text = "admin1234"
    }
    override func viewDidAppear(_ animated: Bool) {
        self.mobileTXT.text = regID
        self.PasswordTXT.text = regPass
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
            switch responce.result{
            case .success( _):
                do{
                    let jsonToSwift = try JSONDecoder().decode(Json4Swift_Base.self, from: responce.data!)
                    self.storedToken = (jsonToSwift.data?.token)!
                    UserDefaults.standard.setValue(self.storedToken, forKey: "stateSelected")
                    
                    let LoadVC = UIAlertController(title: "Status", message: jsonToSwift.message, preferredStyle: .alert)
                    LoadVC.addAction(UIAlertAction(title: "Done", style: .default, handler: { (action) in
                        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AllListItemVC") as! AllListItemVC
                        vc.storedToken = self.storedToken
                        self.navigationController?.pushViewController(vc, animated: true)
                    }))
                    self.present(LoadVC, animated: true, completion: nil)
                }catch let error as NSError{
                    print("Failed To Load :\(error.localizedDescription)")
                }
            case .failure(_):
                let alert:UIAlertController = UIAlertController(title: "Message", message: "Enter Right ID Password", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (alert) in
                    //
                }))
            }
        }
        
    }
    @IBAction func RegisterAsUser(_ sender: UIButton) {
        let VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RegisterVC") as! RegisterVC
        VC.idPass = self
        self.navigationController?.pushViewController(VC, animated: true)
    }
}

