//
//  DictatePlatformViewController.swift
//  SBBZurichNotifier
//
//  Created by Patrick Balestra on 9/17/16.
//  Copyright © 2016 Patrick Balestra. All rights reserved.
//

import UIKit

class DictatePlatformViewController: UIViewController {

    @IBOutlet fileprivate weak var responseLabel: UILabel!
    @IBOutlet fileprivate weak var backgroundView: UIView!
    @IBOutlet fileprivate weak var topView: UIView!
    
    fileprivate let speechRecognizer = SpeechRecognizer()
    var callback: ((Int?) -> ())? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        speechRecognizer.startRecording()
        speechRecognizer.textEvent.addHandler { text, finished in
            
            if finished {
                self.dismiss(animated: true)
            } else {
                self.responseLabel.text = text
            }
        }
        
        topView.layer.shadowColor = UIColor.black.cgColor
        topView.layer.shadowOffset = CGSize(width: 1, height: 1)
        topView.layer.shadowRadius = 3
        topView.layer.shadowOpacity = 0.25
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let animation = UIViewPropertyAnimator(duration: 0.25, curve: .easeIn) {
            self.backgroundView.alpha = 1.0
        }
        animation.startAnimation()
    }

    @IBAction func dismiss(_ sender: AnyObject) {
        let animation = UIViewPropertyAnimator(duration: 0.15, curve: .easeIn) {
            self.backgroundView.backgroundColor = UIColor.clear
        }
        animation.startAnimation()
        animation.addCompletion { _ in
            self.dismiss(animated: true)
        }
    }
    
    @IBAction func confirm(_ sender: AnyObject) {
        speechRecognizer.stopRecording()
        guard let text = responseLabel.text else { return }
        
        var platformNumber: Int?
        if let number = Int(text) {
            platformNumber = number
        } else {
            let platform = parsePlatformAsNumber()
            platformNumber = platform
        }

        dismiss(animated: true)
        self.callback?(platformNumber)

    }
    
    func parsePlatformAsNumber() -> Int? {
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .spellOut
        return numberFormatter.number(from: responseLabel.text!.lowercased())?.intValue
    }
}
