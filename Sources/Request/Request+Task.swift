//
//  Request+FoundationRequest.swift
//  Request
//
//  Created by Bradley Hilton on 2/6/16.
//  Copyright © 2016 Brad Hilton. All rights reserved.
//

extension Request {
    
    fileprivate func foundationRequest() throws -> URLRequest {
        guard let url = URL(self.url) else { throw UnknownError(description: "Invalid URL") }
        var request = URLRequest(url: url)
        request.cachePolicy = cachePolicy
        request.timeoutInterval = timeoutInterval
        request.mainDocumentURL = mainDocumentURL != nil ? URL(mainDocumentURL!) : nil
        request.networkServiceType = networkServiceType
        request.allowsCellularAccess = allowsCellularAccess
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers
        request.httpBody = try body?.serializeToDataWithOptions(options)
        request.httpShouldHandleCookies = shouldHandleCookies
        request.httpShouldUsePipelining = shouldUsePipelining
        return request
    }
    
    internal func task() throws -> URLSessionTask {
        return session.session.dataTask(with: try foundationRequest())
    }
    
}
