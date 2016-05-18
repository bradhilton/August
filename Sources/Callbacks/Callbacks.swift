//
//  Callbacks.swift
//  Request
//
//  Created by Bradley Hilton on 2/6/16.
//  Copyright © 2016 Brad Hilton. All rights reserved.
//

public struct Callbacks {
    
    public var queue = NSOperationQueue.mainQueue()
    public var startCallbacks = [String : StartCallback]()
    public var progressCallbacks = [String : ProgressCallback]()
    public var responseCallbacks = [String : ResponseCallback]()
    public var errorCallbacks = [String : ErrorCallback]()
    public var completionCallbacks = [String : CompletionCallback]()
    
    public var successCallback: SuccessCallback?
    public var failureCallback: FailureCallback?
    
}

public typealias StartCallback = (request: Request) -> Void
public typealias ProgressCallback = (sent: Double, received: Double, request: Request) -> Void
public typealias FailureCallback = (error: ErrorType, request: Request) -> Void
public typealias CompletionCallback = (response: Response<NSData>?, errors: [ErrorType], request: Request) -> Void

public struct ErrorCallback {
    
    let callback: (error: ErrorType, request: Request) -> Void
    
    public init(callback: (error: ErrorType, request: Request) -> Void) {
        self.callback = callback
    }
    
    public init<T : ErrorType>(callback: (error: T, request: Request) -> Void) {
        self.callback = { (error, request) in
            if let error = error as? T {
                callback(error: error, request: request)
            }
        }
    }
    
}

protocol ReponseCallbackProtocol {
    var callback: (response: Response<NSData>, request: Request, queue: NSOperationQueue) throws -> Void { get }
    init(callback: (response: Response<NSData>, request: Request, queue: NSOperationQueue) throws -> Void)
}

public struct ResponseCallback {
    
    let callback: (response: Response<NSData>, request: Request, queue: NSOperationQueue) throws -> Void
    
    public init<T : DataInitializable>(responseCodes: Set<Int>, callback: (response: Response<T>, request: Request) -> Void) {
        self.callback = responseCallback(successCallback: false, responseCodes: responseCodes, callback: callback)
    }
    
}

public struct SuccessCallback {
    
    let callback: (response: Response<NSData>, request: Request, queue: NSOperationQueue) throws -> Void
    
    public init<T : DataInitializable>(responseCodes: Set<Int>, callback: (response: Response<T>, request: Request) -> Void) {
        self.callback = responseCallback(successCallback: true, responseCodes: responseCodes, callback: callback)
    }
    
}

private func responseCallback<T : DataInitializable>(
    successCallback successCallback: Bool,
    responseCodes: Set<Int>,
    callback: (response: Response<T>, request: Request) -> Void)
    -> (response: Response<NSData>, request: Request, queue: NSOperationQueue) throws -> Void
{
    return { (response, request, queue) in
        guard responseCodes.contains(response.statusCode) else {
            if successCallback {
                throw ResponseError(response: response)
            }
            return
        }
        let newResponse = try response.createResponse() as Response<T>
        queue.addOperationWithBlock {
            callback(response: newResponse, request: request)
        }
    }
}