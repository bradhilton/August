//
//  Callbacks.swift
//  Request
//
//  Created by Bradley Hilton on 2/6/16.
//  Copyright © 2016 Brad Hilton. All rights reserved.
//

public typealias StartCallback = (task: Task) -> Void
public typealias ProgressCallback = (task: Task) -> Void
public typealias FailureCallback = (error: ErrorType, request: Request) -> Void
public typealias CompletionCallback = (response: Response<NSData>?, errors: [ErrorType], request: Request) -> Void

internal struct ErrorCallback {
    
    let callback: (error: ErrorType, request: Request) -> Void
    
    init(callback: (error: ErrorType, request: Request) -> Void) {
        self.callback = callback
    }
    
    init<T : ErrorType>(callback: (error: T, request: Request) -> Void) {
        self.callback = { (error, request) in
            if let error = error as? T {
                callback(error: error, request: request)
            }
        }
    }
    
}

protocol ReponseCallbackProtocol {
    var callback: (response: Response<NSData>, queue: NSOperationQueue) throws -> Void { get }
    init(callback: (response: Response<NSData>, queue: NSOperationQueue) throws -> Void)
}

internal struct ResponseCallback {
    
    let callback: (response: Response<NSData>, queue: NSOperationQueue) throws -> Void
    
    init<T : DataInitializable>(responseCodes: Set<Int>, callback: (response: Response<T>) -> Void) {
        self.callback = responseCallback(successCallback: false, responseCodes: responseCodes, callback: callback)
    }
    
}

internal struct SuccessCallback {
    
    let callback: (response: Response<NSData>, queue: NSOperationQueue) throws -> Void
    
    init<T : DataInitializable>(responseCodes: Set<Int>, callback: (response: Response<T>) -> Void) {
        self.callback = responseCallback(successCallback: true, responseCodes: responseCodes, callback: callback)
    }
    
}

private func responseCallback<T : DataInitializable>(
    successCallback successCallback: Bool,
    responseCodes: Set<Int>,
    callback: (response: Response<T>) -> Void)
    -> (response: Response<NSData>, queue: NSOperationQueue) throws -> Void
{
    return { (response, queue) in
        guard responseCodes.contains(response.statusCode) else {
            if successCallback {
                throw ResponseError(response: response)
            }
            return
        }
        let newResponse = try Response<T>(response)
        queue.addOperationWithBlock {
            callback(response: newResponse)
        }
    }
}