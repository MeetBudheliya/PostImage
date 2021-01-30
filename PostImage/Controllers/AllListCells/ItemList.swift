//
//  ItemList.swift
//  PostImage
//
//  Created by MAC on 28/01/21.
//

import UIKit
import Alamofire
class ItemList: UITableViewCell {

    @IBOutlet weak var imgCollection: UICollectionView!
    @IBOutlet weak var titl: UILabel!
    @IBOutlet weak var desc: UILabel!
    var imgData = [String]()
    var x = 0
    override func awakeFromNib() {
        super.awakeFromNib()
    collSetup()
        Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(scrollToNextCell), userInfo: nil, repeats: true)
    }
    func collSetup(){
        imgCollection.delegate = self
        imgCollection.dataSource = self
    
    }
    @objc func scrollToNextCell(){
        self.x = self.x + 1
        if self.x < imgData.count {
            let indexPath = IndexPath(item: x, section: 0)
            self.imgCollection.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }else{
            self.x = 0
            self.imgCollection.scrollToItem(at: IndexPath(item: 0, section: 0), at: .centeredHorizontally, animated: true)
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
extension ItemList:UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imgData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imgCell", for: indexPath) as! imgCell
       
        AF.request(imgData[indexPath.row], method: .get).responseImage { (responses) in
            guard let image = responses.value else{
                return
            }
            cell.img.image = image
        }
        return cell
    }
    
    
}
