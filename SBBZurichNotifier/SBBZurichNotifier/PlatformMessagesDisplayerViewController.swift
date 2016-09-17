//
//  PlatformMessagesDisplayerViewController.swift
//  SBBZurichNotifier
//
//  Created by Patrick Balestra on 9/17/16.
//  Copyright © 2016 Patrick Balestra. All rights reserved.
//

import UIKit

class PlatformMessagesDisplayerViewController: UIViewController {
    
    internal var platform = ""
    internal var messages = LoudspeakerMessages()
    internal var dataSource = [String: [LoudspeakerMessageRecord]]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    @IBOutlet fileprivate weak var platformLabel: UILabel!
    @IBOutlet fileprivate weak var collectionView: UICollectionView!
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        platformLabel.text = platform
        (collectionView.collectionViewLayout as! UICollectionViewFlowLayout).itemSize = CGSize(width: UIScreen.main.bounds.width - 40, height: 100)
        analyzeMessages()
    }
    
    func analyzeMessages() {
        
        var groupedMessages = [String: [LoudspeakerMessageRecord]]()
        for message in messages {
            if groupedMessages.keys.contains(message.am_id) {
                groupedMessages[message.am_id]?.append(message)
            } else {
                groupedMessages[message.am_id] = [message]
            }
        }
        
        var sortedGroupedMessages = groupedMessages
        groupedMessages.forEach { message in
            sortedGroupedMessages[message.key] = message.value.sorted { $0.amd_id < $1.amd_id }
        }
        
        sortedGroupedMessages.forEach { message in
            var string = ""
            message.value.forEach { record in
                string += "\(record.af_text) "
            }
            dataSource[string] = message.value
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func dismiss(_ sender: AnyObject) {
        dismiss(animated: true)
    }
}

extension PlatformMessagesDisplayerViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.keys.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MessageCollectionViewCell.reuseIdentifier, for: indexPath) as! MessageCollectionViewCell
        cell.messageTextView.text = Array(dataSource.keys)[indexPath.row]
        let date = Array(dataSource.values)[indexPath.row ].first?.created_at_date
        cell.titleLabel.text = dateFormatter.string(from: date!)
        return cell
    }
}
