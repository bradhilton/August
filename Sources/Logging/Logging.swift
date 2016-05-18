//
//  Logging.swift
//  Request
//
//  Created by Bradley Hilton on 1/25/16.
//  Copyright © 2016 Brad Hilton. All rights reserved.
//

struct Logging {
    
    static func logRequest(request: NSURLRequest) {
        if let method = request.HTTPMethod, url = request.URL?.absoluteString {
                print("---> \(method) \(url)")
                printHeaderFields(request.allHTTPHeaderFields)
                printBody(request.HTTPBody)
                print("---> END " + bytesDescription(request.HTTPBody))
        }
    }
    
    static func logResponse(response: NSHTTPURLResponse, request: Request, responseTime: NSTimeInterval, data: NSData) {
        print("<--- \(request.method.rawValue) \(request.url.string) (\(response.statusCode), \(responseTimeDescription(responseTime)))")
        printHeaderFields(response.allHeaderFields)
        printBody(data)
        print("<--- END " + bytesDescription(data))
    }
    
    private static func responseTimeDescription(responseTime: NSTimeInterval) -> NSString {
        return NSString(format: "%0.2fs", responseTime)
    }
    
    private static func printHeaders(headers: [String : String]) {
        for (field, value) in headers {
            print("\(field): \(value)")
        }
    }
    
    private static func printHeaderFields(headerFields: [NSObject : AnyObject]?) {
        if let headerFields = headerFields {
            for (field, value) in headerFields {
                print("\(field): \(value)")
            }
        }
    }
    
    private static func printBody(data: NSData?) {
        if let body = data,
            let bodyString = NSString(data: body, encoding: NSUTF8StringEncoding) where bodyString.length > 0 {
                print(bodyString)
        }
    }
    
    private static func bytesDescription(data: NSData?) -> String {
        return "(\(data != nil ? data!.length : 0) bytes)"
    }
    
}