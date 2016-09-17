//
//  LoudspeakerMessage.swift
//  SBBZurichNotifier
//
//  Created by Patrick Balestra on 9/17/16.
//  Copyright © 2016 Patrick Balestra. All rights reserved.
//

import Foundation
import Unbox

var dateFormatter = ISO8601DateFormatter()

struct LoudspeakerMessageRecord {
    let af_text: String
    let am_id: String
    let amd_id: Int
    let lg_bezeichnung: String
    let created_at_date: Date?
}

extension LoudspeakerMessageRecord: Unboxable {
    
    init(unboxer: Unboxer) {
        
        let messageText: String = unboxer.unbox(key: "fields.af_text", isKeyPath: true)
        if let number = Float(messageText) {
            self.af_text = "\(Int(number))"
        } else {
            self.af_text = messageText
        }
        
        self.am_id = unboxer.unbox(key: "fields.am_id", isKeyPath: true)
        self.amd_id = unboxer.unbox(key: "fields.amd_id", isKeyPath: true)
        self.lg_bezeichnung = unboxer.unbox(key: "fields.lg_bezeichnung", isKeyPath: true)
        
        let createdAtDate: String = unboxer.unbox(key: "fields.created_at_date", isKeyPath: true)
        self.created_at_date = dateFormatter.date(from: createdAtDate)
    }
}

