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
    
    public var statusCode: Int {
        return response.statusCode
    }
    
    public var statusMessage: String {
        return NSHTTPURLResponse.localizedStringForStatusCode(statusCode)
    }
    
    public var headers: [String : String] {
        return response.allHeaderFields as? [String : String] ?? [:]
    }
    
    public init<T>(_ response: Response<T>) throws {
        self.request = response.request
        self.body = try Body.initializeWithData(response.data, options: response.request.options)
        self.responseTime = response.responseTime
        self.data = response.data
        self.response = response.response
    }
    
}

extension Response where Body : NSData {
    
    internal init(task: Task, response: NSHTTPURLResponse) {
        self.request = task.request
        self.body = task.body as? Body ?? Body()
        self.responseTime = task.timer.time
        self.data = task.body
        self.response = response
    }
    
}

