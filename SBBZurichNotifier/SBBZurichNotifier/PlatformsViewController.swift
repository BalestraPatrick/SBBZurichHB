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
    
    @IBAction func about(_ sender: AnyObject) {
        let alertController = UIAlertController(title: "Lalalal", message: "Miao", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .destructive, handler: nil))
        present(alertController, animated: true)
    }
    
}

extension PlatformsViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return platforms.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch indexPath.row {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SpeechCell", for: indexPath)
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PlatformCollectionViewCell.reuseIdentifier, for: indexPath) as! PlatformCollectionViewCell
            cell.titleLabel.text = platforms[indexPath.row - 1]
            return cell
        }
    }
}

extension PlatformsViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let destination = UIStoryboard(name: "Platforms", bundle: nil).instantiateViewController(withIdentifier: "DictatePlatformViewController") as! DictatePlatformViewController
            destination.preferredContentSize = CGSize(width: 300, height: 300)
            destination.transitioningDelegate = self
            destination.modalPresentationStyle = .custom

            present(destination, animated: true)
        default:
            performSegue(withIdentifier: "PlatformMessagesDisplayerViewControllerSegue", sender: nil)
        }
    }
}

extension PlatformsViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PlatformMessagesDisplayerViewControllerSegue" {
            let destination = segue.destination as! PlatformMessagesDisplayerViewController
            if let selectedItems = collectionView.indexPathsForSelectedItems, let selection = selectedItems.first {
                let platform = platforms[selection.row - 1]
                destination.platform = platform
                destination.messages = platformsMessages[platform]!
            }
        }
    }
}

extension PlatformsViewController: UIViewControllerTransitioningDelegate {
    
    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController!, sourceViewController source: UIViewController) -> UIPresentationController? {
        return PageSheetPresentationController(presentedViewController: presented, presenting: presenting)
    }
}
