//
//  Logging.swift
//  Request
//
//  Created by Bradley Hilton on 1/25/16.
//  Copyright © 2016 Brad Hilton. All rights reserved.
//

extension Request : CustomDebugStringConvertible {
    
    public var debugDescription: String {
        var description = "---> \(method) \(url)\n"
        addHeaders(&description, headers: headers)
        if let body = body {
            guard let data = try? body.serializeToDataWithOptions(options) else {
                return description + "{ ERROR: Unable to serialize data } \n---> END"
            }
            addData(&description, data: data)
            return description + "\n---> END (\(data.length) bytes)"
        } else {
            return description + "---> END (0 bytes)"
        }
    }
    
    internal func log() {
        if logging { backgroundDebugPrint(self) }
    }
    
}

extension Response : CustomDebugStringConvertible {
    
    public var debugDescription: String {
        var description = "<--- \(request.method) \(request.url) (\(statusCode) \(statusMessage), \(NSString(format: "%0.2fs", responseTime)))\n"
        addHeaders(&description, headers: headers)
        addData(&description, data: data)
        return description + "\n<--- END (\(data.length) bytes)"
    }
    
    internal func log() {
        if request.logging { backgroundDebugPrint(self) }
    }
    
}

private func addHeaders(inout description: String, headers: [String : String]) {
    for (field, value) in headers {
        description += "\(field): \(value)\n"
    }
}

private func addData(inout description: String, data: NSData) {
    if let string = String(data: data, encoding: NSUTF8StringEncoding) where string.characters.count > 0 {
        description += string
    }
}

private func backgroundDebugPrint<T>(value: T) {
    NSOperationQueue().addOperationWithBlock { debugPrint(value) }
}

