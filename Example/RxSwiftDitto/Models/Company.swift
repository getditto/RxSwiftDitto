//
//  Company.swift
//  RxSwiftDitto_Example
//
//  Created by Maximilian Alexander on 5/2/21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import DittoSwift

struct Company: Equatable {

    var id: String
    var title: String
    var details: String
    var editedOn: Date

    init(document: DittoDocument) {
        id = document.id.toString()
        title = document["title"].stringValue
        details = document["details"].stringValue
        editedOn = {
            guard let value = document["editedOn"].string else {
                // for safety just assume now.
                return Date()
            }
            let dateFormatter = ISO8601DateFormatter()
            // parse the ISO8601 date string, if it didn't parse correctly return now for safety
            return dateFormatter.date(from: value) ?? Date()
        }()
    }
}
