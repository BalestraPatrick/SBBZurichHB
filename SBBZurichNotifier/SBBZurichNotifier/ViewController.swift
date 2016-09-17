//
//  ViewController.swift
//  SBBZurichNotifier
//
//  Created by Patrick Balestra on 9/16/16.
//  Copyright © 2016 Patrick Balestra. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet private weak var collectionView: UICollectionView!
    
    var dataSource: [String: Any] = [:]
    
    var platforms: [String] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.barTintColor = UIColor.clear
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.barStyle = .black
        self.title = "Platforms"
        
        LoudspeakerMessageRequest().getMessages(forPlatform: "41/42") { messages in
            var platforms = [String]()
            messages.forEach { message in
                if let platform = message.value.first?.lg_bezeichnung, platforms.contains(platform) == false {
                    platforms.append(platform)
                }
            }
            self.platforms = platforms
            self.dataSource = messages
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

extension ViewController: UICollectionViewDataSource {
    
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
