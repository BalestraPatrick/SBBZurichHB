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

typealias LoudspeakerMessages = [LoudspeakerMessageRecord]

class LoudspeakerMessageRequest {
    
    internal typealias MessagesResponse = ([String: [LoudspeakerMessageRecord]]) -> ()
    
    fileprivate lazy var baseURLComponents: URLComponents = {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "data.sbb.ch"
        components.path = "/api/records/1.0/search"
        return components
    }()

    func getAllPlatformMessages(completion: @escaping MessagesResponse) {

        var speakerMessagesURL = baseURLComponents
        speakerMessagesURL.queryItems = [
            URLQueryItem(name: "dataset", value: "loudspeaker-messages"),
            URLQueryItem(name: "rows", value: "250"),
            URLQueryItem(name: "facet", value: "lg_bezeichnung"),
            URLQueryItem(name: "sort", value: "-amd_id"),
            URLQueryItem(name: "created_at_date", value: ">2016-08-26T12:55:02+00:00")
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
                    
                    // Group messages based on the platform number.
                    var groupedMessages = [String: [LoudspeakerMessageRecord]]()
                    for message in messages {
                        if groupedMessages.keys.contains(message.lg_bezeichnung) {
                            groupedMessages[message.lg_bezeichnung]?.append(message)
                        } else {
                            groupedMessages[message.lg_bezeichnung] = [message]
                        }
                    }
                    completion(groupedMessages)
                }
        }
    }
}
