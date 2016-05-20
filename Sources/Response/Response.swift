//
//  Response.swift
//  Request
//
//  Created by Bradley Hilton on 1/21/16.
//  Copyright © 2016 Brad Hilton. All rights reserved.
//

public struct Response<Body : DataInitializable> {
    
    public let request: Request
    public let body: Body
    public let responseTime: NSTimeInterval
    internal let data: NSData
    internal let response: NSHTTPURLResponse
    internal let options: [ConvertibleOption]
    
    internal init(request: Request, body: Body, responseTime: NSTimeInterval, data: NSData, response: NSHTTPURLResponse, options: [ConvertibleOption]) {
        self.request = request
        self.body = body
        self.responseTime = responseTime
        self.data = data
        self.response = response
        self.options = options
    }
    
    public init<T>(_ response: Response<T>) throws {
        try self.init(request: response.request,
                      body: Body.initializeWithData(response.data, options: response.options),
                      responseTime: response.responseTime, data: response.data,
                      response: response.response,
                      options: response.options)
    }
    
    public var statusCode: Int {
        return response.statusCode
    }
    
    public var statusMessage: String {
        return NSHTTPURLResponse.localizedStringForStatusCode(statusCode)
    }
    
    public var headers: [String : String] {
        return response.allHeaderFields as? [String : String] ?? [:]
    }
    
}

