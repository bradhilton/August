//
//  Request+FoundationRequest.swift
//  Request
//
//  Created by Bradley Hilton on 2/6/16.
//  Copyright © 2016 Brad Hilton. All rights reserved.
//

extension Request {
    
    public func foundationRequest() throws -> NSURLRequest {
        let request = NSMutableURLRequest()
        request.URL = NSURL(string: url.string)
        request.cachePolicy = cachePolicy
        request.timeoutInterval = timeoutInterval
        request.mainDocumentURL = mainDocumentURL != nil ? NSURL(string: mainDocumentURL!.string) : nil
        request.networkServiceType = networkServiceType
        request.allowsCellularAccess = allowsCellularAccess
        request.HTTPMethod = method.rawValue
        request.allHTTPHeaderFields = headers
        request.HTTPBody = try body?.serializeToDataWithOptions(options)
        request.HTTPShouldHandleCookies = shouldHandleCookies
        request.HTTPShouldUsePipelining = shouldUsePipelining
        return request
    }
    
}