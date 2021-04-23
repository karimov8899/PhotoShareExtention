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
    
    //Variables
    let savedata =  UserDefaults.init(suiteName: "group.com.pressure.PhotoShare")
    
    //LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionViewSetUp()
    }
     
    //Setting up CollectionView
    fileprivate func collectionViewSetUp() {
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
    
    
    //Collection View methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let data = savedata?.value(forKey: "images") as? [String]
        return data?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCell", for: indexPath)
        
        //Image view for cell
        let imageView: UIImageView = {
            let image = UIImageView(frame: myCell.bounds)
            image.clipsToBounds = true
            image.contentMode = .scaleAspectFill
            return image
        }()
        
        //Loading image data from url
        if let data = savedata?.value(forKey: "images") as? [String] {
            imageView.image = loadImage(at: data[indexPath.row])
        }
        
        myCell.addSubview(imageView)
        return myCell
    }
    
    
    //Method for loading image from documents directory
    func loadImage(at path: String) -> UIImage? {
        
        //AppGroup Documnet directory
        guard let a = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.pressure.PhotoShare") else {
            return nil
        }
        
        //Path for Image
        let imagePath = a.path + "/" + path
        
        //Checking if file exists
        guard fileExists(at: imagePath) else {
            return nil
        }
        
        //Reading image from path
        guard let image = UIImage(contentsOfFile: imagePath) else {
            return nil
        }
        
        return image
    }
    
    //Method for checking if file exists in dir
    func fileExists(at path: String) -> Bool {
        return FileManager.default.fileExists(atPath: path)
    }
}

