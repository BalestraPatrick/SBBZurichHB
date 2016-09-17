//
//  PlatformCollectionViewCell.swift
//  SBBZurichNotifier
//
//  Created by Patrick Balestra on 9/17/16.
//  Copyright © 2016 Patrick Balestra. All rights reserved.
//

import UIKit

class PlatformCollectionViewCell: UICollectionViewCell {

    public static let reuseIdentifier = "PlatformCollectionViewCell"
    
    @IBOutlet  weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 12.0
        layer.masksToBounds = true
    }
}
