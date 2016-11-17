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
            return description + "\n---> END (\(data.count) bytes)"
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
        return description + "\n<--- END (\(data.count) bytes)"
    }
    
    internal func log() {
        if request.logging { backgroundDebugPrint(self) }
    }
    
}

private func addHeaders(_ description: inout String, headers: [String : String]) {
    for (field, value) in headers {
        description += "\(field): \(value)\n"
    }
}

private func addData(_ description: inout String, data: Data) {
    if let string = String(data: data, encoding: String.Encoding.utf8) {
        description += string
    }
}

private let loggingQueue = OperationQueue()

private func backgroundDebugPrint<T>(_ value: T) {
    loggingQueue.addOperation { debugPrint(value) }
}
