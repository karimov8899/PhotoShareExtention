//
//  ShareViewController.swift
//  ShareList
//
//  Created by Dave on 4/20/21.
//

import UIKit
import MobileCoreServices
import Social

class ShareViewController: SLComposeServiceViewController {
    private let groupName = "group.com.pressure.PhotoShare" 
    var images = [String]()
    func share() {
        let inputItem = extensionContext!.inputItems.first! as! NSExtensionItem
        let attachment = inputItem.attachments as! [NSItemProvider]
        for a in attachment.indices {
            if attachment[a].hasItemConformingToTypeIdentifier( kUTTypeImage as String) {
                attachment[a].loadItem(forTypeIdentifier: kUTTypeImage as String, options: [:]) { (data, error) in
                    var image: UIImage?
                    
                    if let url = data as? URL,
                       let imageData = try? Data(contentsOf: url) {
                        self.images.append(url.path)
                        print(url.path)
                    } else {
                        // Handle this situation as you prefer
                        fatalError("Impossible to save image")
                    }
                    
                    if let someURl = data as? URL {
                        image = UIImage(contentsOfFile: someURl.path)
                    }else if let someImage = data as? UIImage {
                        image = someImage
                    }
                }
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: { [weak self] in
            guard let strongSelf = self else {return}
            do {
                let savedata =  UserDefaults.init(suiteName: strongSelf.groupName)
                savedata?.set(strongSelf.images, forKey: "images")
                savedata?.synchronize()
                print(strongSelf.images)
                
            } catch {
                
            }
            
        })
    }
    override func isContentValid() -> Bool {
        // Do validation of contentText and/or NSExtensionContext attachments here
        return true
    }
    override func didSelectPost() {
        share()
    }
}

