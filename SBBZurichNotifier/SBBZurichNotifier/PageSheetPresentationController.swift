//
//  PageSheetPresentationController.swift
//  SBBZurichNotifier
//
//  Created by Patrick Balestra on 9/17/16.
//  Copyright © 2016 Patrick Balestra. All rights reserved.
//

import UIKit

class PageSheetPresentationController: UIPresentationController {
    
    override var frameOfPresentedViewInContainerView: CGRect {
        return CGRect(x: 20, y: 100, width: containerView!.bounds.width - 40, height: containerView!.bounds.height/2)
    }
}
