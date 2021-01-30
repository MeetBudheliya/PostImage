//
//  AllListItemVC.swift
//  PostImage
//
//  Created by MAC on 28/01/21.
//

import UIKit
import Alamofire
import AlamofireImage
import SwiftyJSON
class AllListItemVC: UIViewController {
    @IBOutlet weak var mainTBL: UITableView!
    var storedToken = String()
    var AllDataList = [ItemsData]()
    override func viewDidLoad() {
        super.viewDidLoad()
       tableSetup()
        GetData()
        self.navigationController?.navigationItem.title = "\(AllDataList.count) Items Available"
    }
    override func viewDidAppear(_ animated: Bool) {
        GetData()
        self.navigationController?.navigationItem.title = "\(AllDataList.count) Items Available"
    }
    func tableSetup(){
        mainTBL.delegate = self
        mainTBL.dataSource = self
    }
    func GetData(){
        let headers:HTTPHeaders = ["Authorization": "Bearer \(storedToken)", "Content-type": "multipart/form-data"]
        AF.request("https://adsumoriginator.com/apidemo/api/list_item", method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers, interceptor: nil, requestModifier: nil).response{ (responses) in
            print(responses)
            do{
                let jsonData = try! JSONDecoder().decode(itemmodel.self, from: responses.data!)
                    print(jsonData.status as Any)
                self.AllDataList.removeAll();                self.AllDataList.append(contentsOf: jsonData.data!)
                self.mainTBL.reloadData()
            }catch{
                print("Failed To Load\(error.localizedDescription)")
            }
        }
    }
    
    @IBAction func AddItemBTN(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "CreateItemSegue", sender: nil)
    }
}
extension AllListItemVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AllDataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemList") as! ItemList
        cell.titl.text = AllDataList[indexPath.row].title
        cell.desc.text = AllDataList[indexPath.row].description
        cell.imgData = AllDataList[indexPath.row].image!
        return cell
    }
    
    
}
