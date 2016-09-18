//
//  MessageCollectionViewCell.swift
//  SBBZurichNotifier
//
//  Created by Patrick Balestra on 9/17/16.
//  Copyright © 2016 Patrick Balestra. All rights reserved.
//

import UIKit
import AVFoundation

class MessageCollectionViewCell: UICollectionViewCell {
 
    public static let reuseIdentifier = "MessageCollectionViewCell"
    
    @IBOutlet internal weak var titleLabel: UILabel!
    @IBOutlet internal weak var messageLabel: UILabel!
    @IBOutlet private weak var widthConstraint: NSLayoutConstraint!
    weak var controller: PlatformMessagesDisplayerViewController?
    var indexPath: IndexPath?
    
    private lazy var synthesizer = AVSpeechSynthesizer()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = 12.0
        layer.masksToBounds = true
        widthConstraint.constant = UIScreen.main.bounds.width - 40
    }
    
    @IBAction func speak(_ sender: AnyObject) {
        controller?.speak(text: messageLabel.text!, indexPath: indexPath)
    }
}
