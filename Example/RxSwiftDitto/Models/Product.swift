//
//  Product.swift
//  RxSwiftDitto_Example
//
//  Created by Maximilian Alexander on 5/2/21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import Foundation
import DittoSwift

struct Product: Equatable {
    var id: String
    var title: String
    var details: String
    var editedOn: Date
    var companyId: String

    init(document: DittoDocument) {
        id = document.id.toString()
        title = document["title"].stringValue
        details = document["details"].stringValue
        editedOn = {
            guard let value = document["editedOn"].string else {
                return Date()
            }
            let dateFormatter = ISO8601DateFormatter()
            return dateFormatter.date(from: value) ?? Date()
        }()
        companyId = document["companyId"].stringValue
    }
}
