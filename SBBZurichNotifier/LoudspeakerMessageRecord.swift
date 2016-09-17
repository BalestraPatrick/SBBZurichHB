//
//  LoudspeakerMessage.swift
//  SBBZurichNotifier
//
//  Created by Patrick Balestra on 9/17/16.
//  Copyright © 2016 Patrick Balestra. All rights reserved.
//

import Foundation
import Unbox

struct LoudspeakerMessageRecord {
    let af_text: String
    let am_id: String
    let amd_id: Int
    let lg_bezeichnung: String
}

extension LoudspeakerMessageRecord: Unboxable {
    
    init(unboxer: Unboxer) {
        
        self.af_text = unboxer.unbox(key: "fields.af_text", isKeyPath: true)
        self.am_id = unboxer.unbox(key: "fields.am_id", isKeyPath: true)
        self.amd_id = unboxer.unbox(key: "fields.amd_id", isKeyPath: true)
        self.lg_bezeichnung = unboxer.unbox(key: "fields.lg_bezeichnung", isKeyPath: true)
    }
}
