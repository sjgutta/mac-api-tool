//
//  CustomeResponse.swift
//  Mac API Tool
//
//  Created by Sajan  Gutta on 12/9/20.
//

import Foundation

class CustomResponse {
    var statusCode: String
    var json_data: NSString
    var isError: Bool
    
    init(status: Int, data: NSString, error: Bool = true) {
        self.statusCode = String(status)
        self.json_data = data
        self.isError = error
    }
    init(status: String, data: NSString, error: Bool = true) {
        self.statusCode = status
        self.json_data = data
        self.isError = error
    }
}
