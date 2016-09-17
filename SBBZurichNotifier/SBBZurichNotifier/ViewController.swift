//
//  ViewController.swift
//  SBBZurichNotifier
//
//  Created by Patrick Balestra on 9/16/16.
//  Copyright © 2016 Patrick Balestra. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        LoudspeakerMessageRequest().getMessages(forPlatform: "41/42") { messages in
            print(messages)
            messages.forEach { message in
                message.value.forEach({ (record) in
                    
                })
            }
        }
    }
}
