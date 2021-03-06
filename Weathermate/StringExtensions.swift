//
//  StringExtensions.swift
//  Weathermate
//
//  Created by parry on 7/22/16.
//  Copyright © 2016 MCP. All rights reserved.
//

import Foundation


extension String {
    func replace(_ string:String, replacement:String) -> String {
        return self.replacingOccurrences(of: string, with: replacement, options: NSString.CompareOptions.literal, range: nil)
    }

    func removeWhitespace() -> String {
        return self.replace(" ", replacement: "")
    }
}
