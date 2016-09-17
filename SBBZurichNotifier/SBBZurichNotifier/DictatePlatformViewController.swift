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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let speechRecognizer = SpeechRecognizer()
        speechRecognizer.startRecording()
        speechRecognizer.textEvent.addHandler { text, finished in
            
            if finished {
                
            } else {
                self.responseLabel.text = text
            }
        }
    
    }

}
