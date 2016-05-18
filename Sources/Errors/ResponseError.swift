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
        switch response.statusCode {
        case 400..<500: return "Client Error: Returned \(response.statusCode)"
        case 500..<600: return "Server Error: Returned \(response.statusCode)"
        default: return "Unexpected Response: Returned \(response.statusCode)"
        }
    }
    
}
