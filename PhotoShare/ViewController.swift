//
//  ViewController.swift
//  PhotoShare
//
//  Created by Dave on 4/20/21.
//

import UIKit
import MobileCoreServices
import Social
class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    let savedata =  UserDefaults.init(suiteName: "group.com.pressure.PhotoShare")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: 120, height: 120)
        
        let myCollectionView:UICollectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        myCollectionView.dataSource = self
        myCollectionView.delegate = self
        myCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "MyCell")
        myCollectionView.backgroundColor = UIColor.white
        self.view.addSubview(myCollectionView)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let data = savedata?.value(forKey: "images") as? [String]
        return data?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCell", for: indexPath)
        let imageView: UIImageView = {
            let image = UIImageView(frame: myCell.bounds)
            image.clipsToBounds = true
            image.contentMode = .scaleAspectFill
            return image
        }()
        if savedata?.value(forKey: "images") != nil {
            print("Available Data")
            let data = savedata?.value(forKey: "images") as? [String]
            do {
                let url = URL(fileURLWithPath: data![indexPath.row])
                if let imageData = try? Data(contentsOf: url) {
                    imageView.image = UIImage(data: imageData)
                    print(url)
                } else {
                     
                }
            } catch  {
                print("No")
            }
             
        }
        myCell.addSubview(imageView)
        myCell.backgroundColor = UIColor.blue
        return myCell
    }
}

