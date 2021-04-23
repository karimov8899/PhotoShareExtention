//
//  ShareViewController.swift
//  ShareList
//
//  Created by Dave on 4/20/21.
//

import UIKit
import MobileCoreServices
import Social

class ShareViewController: UIViewController {
    
    //Variables
    private let groupName = "group.com.pressure.PhotoShare" 
    var images = [String]()
    
    //LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        handleSharedData()
    }
    
    //Function for handling shared data
    private func handleSharedData() {
        let inputItem = extensionContext!.inputItems.first! as! NSExtensionItem
        let attachment = inputItem.attachments!
        for item in attachment.indices {
            if attachment[item].hasItemConformingToTypeIdentifier( kUTTypeImage as String) {
                attachment[item].loadItem(forTypeIdentifier: kUTTypeImage as String, options: [:]) { (data, error) in
                    if let url = data as? URL, let imageData = try? Data(contentsOf: url) {
                        //Saving files into AppGroup Documents directory
                        guard let dir = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: self.groupName) else {return}
                        let file = dir.appendingPathComponent(url.lastPathComponent)
                        try? imageData.write(to: file, options: .atomic)
                        self.images.append(url.lastPathComponent)
                    } else {
                        fatalError("Impossible to save image")
                    }
                }
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: { [weak self] in
            guard let strongSelf = self else {return}
            strongSelf.saveTheFileNames()
        })
    }
    
    //Method for saving FileNames
    func saveTheFileNames() {
        let savedata =  UserDefaults.init(suiteName: self.groupName)
        savedata?.set(images, forKey: "images")
        savedata?.synchronize()
        extensionContext?.completeRequest(returningItems: nil, completionHandler: nil)
    }
}

