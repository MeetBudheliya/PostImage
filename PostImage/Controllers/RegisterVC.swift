//
//  RegisterVC.swift
//  GetPostData
//
//  Created by MAC on 21/12/20.
//

import UIKit
enum ApiError:Error{
    case ResponseProblem
    case DecodingProblem
    case OtherProblem
}
protocol SendIdPassToLogin{
    func sendIdPassword(id:String,password:String)
}
class RegisterVC: UIViewController {
    @IBOutlet weak var HideShow: UIButton!
    @IBOutlet weak var warningLBL: UILabel!
    var hidden:Bool?
    @IBOutlet weak var nametxt: UITextField!
    @IBOutlet weak var emailtxt: UITextField!
    @IBOutlet weak var phonetxt: UITextField!
    @IBOutlet weak var passwordtxt: UITextField!
    @IBOutlet weak var confirmPasswordtxt: UITextField!
    var idPass:SendIdPassToLogin?
    override func viewDidLoad() {
        super.viewDidLoad()
        //       if HideShow.isSelected == true
        //        {
        //            self.HiddenFalse()
        //        }
        
        // Do any additional setup after loading the view.
        
    }
    override func viewDidAppear(_ animated: Bool) {
        // hiddentrue()
    }
    func hiddentrue(){
        hidden = true
        passwordtxt.isSecureTextEntry = true
        HideShow.setImage(UIImage(systemName: "eye.fill"), for: .normal)
    }
    func HiddenFalse() {
        hidden = false
        passwordtxt.isSecureTextEntry = false
        HideShow.setImage(UIImage(systemName: "eye.slash.fill"), for: .normal)
    }
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    func isValidMobile(value: String) -> Bool {
             let PHONE_REGEX = "^\\d{10}$"
             let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
             let result = phoneTest.evaluate(with: value)
             return result
         }
    @IBAction func registerBTN(_ sender: UIButton) {
        guard (nametxt.text != nil && nametxt.text != "") &&  (emailtxt.text != nil && emailtxt.text != "") && (phonetxt.text != nil && phonetxt.text != "") && (passwordtxt.text != nil && passwordtxt.text != "") && (confirmPasswordtxt.text != nil && confirmPasswordtxt.text != "") else {
            warningLBL.text = "TextFields Not Contains Blank Value"
            return
        }
        guard  isValidEmail(emailtxt.text!) == true else {
            warningLBL.text = "Enter Valid MailID"
            return
        }
        guard isValidMobile(value: phonetxt.text!) else {
            warningLBL.text = "Enter Valid Mobile Number"
            return
        }
        guard passwordtxt.text!.count >= 8 && passwordtxt.text!.count <= 12 else {
            warningLBL.text = "Password must have 8-12 Character"
            return
        }
        guard passwordtxt.text == confirmPasswordtxt.text else {
            warningLBL.text = "ConfirmPassword must be same as Password"
            return
        }
        
        let parameters: [String: String] = ["name": nametxt.text!, "email": emailtxt.text!, "phone": phonetxt.text!, "password": passwordtxt.text!, "confirmPassword": confirmPasswordtxt.text!]
        let url = URL(string: "https://adsumoriginator.com/apidemo/api/register")! //change the url
        var request = URLRequest(url: url)
        request.httpMethod = "POST" //set http method as POST
        do{
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        }catch let error {
            print(error.localizedDescription)
            print("reqestPostError")
        }
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task =  URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
            
            guard let jsonData = data else {
                print("Data Not Found")
                return
            }
            do{
                if let json = try JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) as? [String:Any] {
             print(json)
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3){
                        self.idPass?.sendIdPassword(id: self.phonetxt.text!, password: self.passwordtxt.text!)
                        self.navigationController?.popViewController(animated: true)
                    }
                   
                }
                
            }catch let error {
                print(error.localizedDescription)
                print("DataDecodeError")
            }
        })
        task.resume()
//        
//        let errorCheck = URLSession.shared.dataTask(with: url) { (data, response, error) in
//            guard let dataa = data else{
//                return
//            }
//            do{
//                let errorr = try JSONDecoder().decode(ErrorMessage.self,from: dataa)
//                print(errorr.messages as Any)
//            }catch{
//                print("No Error")
//            }
//        }
//        errorCheck.resume()
        warningLBL.text = ""
    }
    @IBAction func alreadyAccount(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func HideShow(_ sender: UIButton) {
        if hidden == true
        {
            HiddenFalse()
        }
        else
        {
            hiddentrue()
        }
    }
    
    
}
extension RegisterVC:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nametxt.endEditing(true)
        emailtxt.endEditing(true)
        phonetxt.endEditing(true)
        passwordtxt.endEditing(true)
        confirmPasswordtxt.endEditing(true)
        return true
    }
}
