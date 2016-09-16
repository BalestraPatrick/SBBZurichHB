//
//  LoudspeakerMessagesRequest.swift
//  SBBZurichNotifier
//
//  Created by Patrick Balestra on 9/16/16.
//  Copyright © 2016 Patrick Balestra. All rights reserved.
//

import Foundation
import Alamofire
import Unbox

class LoudspeakerMessageRequest {
    
    typealias Response = () -> ()
    
    fileprivate lazy var baseURLComponents: URLComponents = {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "data.sbb.ch"
        components.path = "/api/records/1.0/search"
        return components
    }()

    func get() {

        var speakerMessagesURL = baseURLComponents
        speakerMessagesURL.queryItems = [
            URLQueryItem(name: "dataset", value: "loudspeaker-messages"),
            URLQueryItem(name: "q", value: "lg_bezeichnung=8"),
        ]
        
        Alamofire.request(speakerMessagesURL.url!, encoding: JSONEncoding.default, headers: nil)
            .responseJSON { response in
                guard response.result.isSuccess else { return print("Error")}
                
                if let data = response.data {
                    let json = try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as! UnboxableDictionary
                    let records = json["records"] as! [UnboxableDictionary]
                    let messages = records.map { record  -> LoudspeakerMessageRecord in
                        let message: LoudspeakerMessageRecord = try! Unbox(dictionary: record)
                        return message
                    }
                    
                    print(messages)
                }
        }
    }
}
