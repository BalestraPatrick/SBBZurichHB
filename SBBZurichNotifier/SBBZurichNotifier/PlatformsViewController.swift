//
//  ViewController.swift
//  SBBZurichNotifier
//
//  Created by Patrick Balestra on 9/16/16.
//  Copyright © 2016 Patrick Balestra. All rights reserved.
//

import UIKit

class PlatformsViewController: UIViewController {
    
    fileprivate var selectedIndexPath: IndexPath? = nil
    fileprivate var platforms: [String] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    fileprivate var platformsMessages: [String: LoudspeakerMessages] = [:] {
        didSet {
            var platforms = [String]()
            platformsMessages.forEach { message in
                if let platform = message.value.first?.lg_bezeichnung, platforms.contains(platform) == false {
                    platforms.append(platform)
                }
            }
            self.platforms = platforms
        }
    }
    
    @IBOutlet fileprivate weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Platforms"
        navigationController?.navigationBar.barTintColor = UIColor.clear
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.barStyle = .black
                
        LoudspeakerMessageRequest().getAllPlatformMessages() { platformMessages in
            self.platformsMessages = platformMessages
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let selectedItems = collectionView.indexPathsForSelectedItems, let selection = selectedItems.first {
            collectionView.deselectItem(at: selection, animated: true)
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

extension PlatformsViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return platforms.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PlatformCollectionViewCell.reuseIdentifier, for: indexPath) as! PlatformCollectionViewCell
        cell.titleLabel.text = platforms[indexPath.row]
        return cell
    }
}

extension PlatformsViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PlatformMessagesDisplayerViewControllerSegue" {
            let destination = segue.destination as! PlatformMessagesDisplayerViewController
            if let selectedItems = collectionView.indexPathsForSelectedItems, let selection = selectedItems.first {
                let platform = platforms[selection.row]
                destination.platform = platform
                destination.messages = platformsMessages[platform]!
            }
        }
    }
    
    func messages(messages: [String: LoudspeakerMessages], for platform: String) -> [String : LoudspeakerMessages] {
        return [:]
//        return messages.filter({ message -> Bool in
//            message.value
//        })
    }
}