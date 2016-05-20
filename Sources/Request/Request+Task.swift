//
//  Request+FoundationRequest.swift
//  Request
//
//  Created by Bradley Hilton on 2/6/16.
//  Copyright © 2016 Brad Hilton. All rights reserved.
//

extension Request {
    
    private func foundationRequest() throws -> NSURLRequest {
        let request = NSMutableURLRequest()
        request.URL = NSURL(url)
        request.cachePolicy = cachePolicy
        request.timeoutInterval = timeoutInterval
        request.mainDocumentURL = mainDocumentURL != nil ? NSURL(mainDocumentURL!) : nil
        request.networkServiceType = networkServiceType
        request.allowsCellularAccess = allowsCellularAccess
        request.HTTPMethod = method.rawValue
        request.allHTTPHeaderFields = headers
        request.HTTPBody = try body?.serializeToDataWithOptions(options)
        request.HTTPShouldHandleCookies = shouldHandleCookies
        request.HTTPShouldUsePipelining = shouldUsePipelining
        return request
    }
    
    internal func task() throws -> NSURLSessionTask {
        return session.session.dataTaskWithRequest(try foundationRequest())
    }
    
}