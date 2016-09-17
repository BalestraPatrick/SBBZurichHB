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
        return numberFormatter.number(from: responseLabel.text!.lowercased()) as Int?
    }
}
