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
    
    @IBOutlet fileprivate weak var platformLabel: UILabel!
    @IBOutlet fileprivate weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()

        platformLabel.text = platform
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
            message.value.forEach { record in
                print("\(record.af_text):   \(record.am_id)       \(record.amd_id)")
            }
        }
    }
    
    @IBAction func dismiss(_ sender: AnyObject) {
        dismiss(animated: true)
    }
}
