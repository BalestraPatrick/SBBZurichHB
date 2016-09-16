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
        
        let request = LoudspeakerMessageRequest().get()
    }
}
