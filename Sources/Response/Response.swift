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
    public let responseTime: TimeInterval
    internal let data: Data
    internal let response: HTTPURLResponse
    
    public var statusCode: Int {
        return response.statusCode
    }
    
    public var statusMessage: String {
        return HTTPURLResponse.localizedString(forStatusCode: statusCode)
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
    
    init(task: Task, response: HTTPURLResponse) {
        self.request = task.request
        self.body = task.body as! Body
        self.responseTime = task.timer.time
        self.data = task.body
        self.response = response
    }
    
}

