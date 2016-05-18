//
//  Response.swift
//  Request
//
//  Created by Bradley Hilton on 1/21/16.
//  Copyright © 2016 Brad Hilton. All rights reserved.
//

public struct Response<Body : DataInitializable> {
    
    public let body: Body
    public let foundationResponse: NSHTTPURLResponse
    public let responseTime: NSTimeInterval
    internal let options: [ConvertibleOption]
    
    public var statusCode: Int {
        return foundationResponse.statusCode
    }
    
    public var headers: [String : String] {
        return foundationResponse.allHeaderFields as? [String : String] ?? [:]
    }
    
}

extension Response where Body : NSData {
    
    public func createResponse<T : DataInitializable>() throws -> Response<T> {
        return try Response<T>(body: T.initializeWithData(body, options: options), foundationResponse: foundationResponse, responseTime: responseTime, options: options)
    }
    
    internal func handleResponse<T : DataInitializable>(handler: (Response<T>, Request) -> Void) {
        NSOperationQueue().addOperationWithBlock {
            
        }
    }
    
}