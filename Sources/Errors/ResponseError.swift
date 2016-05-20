//
//  Error.swift
//  Request
//
//  Created by Bradley Hilton on 1/21/16.
//  Copyright © 2016 Brad Hilton. All rights reserved.
//

public struct ResponseError : ErrorType, CustomStringConvertible {
    
    public var response: Response<NSData>
    
    public var description: String {
        let message = "\(response.statusCode) \(response.statusMessage)"
        switch response.statusCode {
        case 400..<500: return "Client Error: \(message)"
        case 500..<600: return "Server Error: \(message)"
        default: return "Unexpected Response: \(message)"
        }
    }
    
}
