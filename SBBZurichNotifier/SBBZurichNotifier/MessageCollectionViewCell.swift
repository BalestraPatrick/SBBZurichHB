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
    @IBOutlet internal weak var messageTextView: UITextView!
    
    private lazy var synthesizer = AVSpeechSynthesizer()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = 12.0
        layer.masksToBounds = true
    }
    
    @IBAction func speak(_ sender: AnyObject) {
        
        if synthesizer.isPaused {
            synthesizer.continueSpeaking()
        } else if synthesizer.isSpeaking {
            synthesizer.pauseSpeaking(at: .word)
        } else {
            let utterance = AVSpeechUtterance(string: messageTextView.text)
            utterance.voice = AVSpeechSynthesisVoice(language: "de_DE")
            utterance.rate = 0.35
            synthesizer.speak(utterance)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
}
