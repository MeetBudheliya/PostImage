//
//  AllListItemVC.swift
//  PostImage
//
//  Created by MAC on 28/01/21.
//

import UIKit

class AllListItemVC: UIViewController {
    @IBOutlet weak var mainTBL: UITableView!
    var storedToken = String()
    override func viewDidLoad() {
        super.viewDidLoad()
       tableSetup()
    }
    func tableSetup(){
        mainTBL.delegate = self
        mainTBL.dataSource = self
    }
    
    @IBAction func AddItemBTN(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "CreateItemSegue", sender: nil)
    }
}
extension AllListItemVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemList") as! ItemList
        cell.titl.text = "Heading"
        cell.desc.text = "this is description of tjhis image collection in this post"
        return cell
    }
    
    
}
