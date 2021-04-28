//
//  Helper.swift
//  RxSwiftDitto
//
//  Created by Maximilian Alexander on 4/28/21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import Foundation

struct Helper {

    static var licenseToken: String {
        let path = Bundle.main.path(forResource: "license_token", ofType: "txt") // file path for file "data.txt"
        guard let text = try? String(contentsOfFile: path!) else {
            fatalError("please add a file called license_token.txt to the bundle and paste a valid Ditto license token")
        }
        return text
    }
}
