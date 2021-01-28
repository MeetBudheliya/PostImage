//
//  ItemList.swift
//  PostImage
//
//  Created by MAC on 28/01/21.
//

import UIKit

class ItemList: UITableViewCell {

    @IBOutlet weak var imgCollection: UICollectionView!
    @IBOutlet weak var titl: UILabel!
    @IBOutlet weak var desc: UILabel!
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
        if self.x < 5 {
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
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imgCell", for: indexPath) as! imgCell
        cell.img.image = #imageLiteral(resourceName: "1")
        return cell
    }
    
    
}
