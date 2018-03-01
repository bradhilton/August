//
//  Callbacks.swift
//  Request
//
//  Created by Bradley Hilton on 2/6/16.
//  Copyright © 2016 Brad Hilton. All rights reserved.
//

public typealias ChallengeCallback = (_ challenge: URLAuthenticationChallenge) -> (URLSession.AuthChallengeDisposition, URLCredential?)
public typealias StartCallback = (_ task: Task) -> Void
public typealias ProgressCallback = (_ task: Task) -> Void
public typealias FailureCallback = (_ error: Error, _ request: Request) -> Void
public typealias CompletionCallback = (_ response: Response<Data>?, _ errors: [Error], _ request: Request) -> Void

internal struct ErrorCallback {
    
    let callback: (_ error: Error, _ request: Request) -> Void
    
    init(callback: @escaping (_ error: Error, _ request: Request) -> Void) {
        self.callback = callback
    }
    
    init<T : Error>(callback: @escaping (_ error: T, _ request: Request) -> Void) {
        self.callback = { (error, request) in
            if let error = error as? T {
                callback(error, request)
            }
        }
    }
    
}

protocol ReponseCallbackProtocol {
    var callback: (_ response: Response<Data>, _ queue: OperationQueue) throws -> Void { get }
    init(callback: (_ response: Response<Data>, _ queue: OperationQueue) throws -> Void)
}

internal struct ResponseCallback {
    
    let callback: (_ response: Response<Data>, _ queue: OperationQueue) throws -> Void
    
    init<T>(responseCodes: Set<Int>, callback: @escaping (_ response: Response<T>) -> Void) {
        self.callback = responseCallback(successCallback: false, responseCodes: responseCodes, callback: callback)
    }
    
}

internal struct SuccessCallback {
    
    let callback: (_ response: Response<Data>, _ queue: OperationQueue) throws -> Void
    
    init<T>(responseCodes: Set<Int>, callback: @escaping (_ response: Response<T>) -> Void) {
        self.callback = responseCallback(successCallback: true, responseCodes: responseCodes, callback: callback)
    }
    
}

private func responseCallback<T>(
    successCallback: Bool,
    responseCodes: Set<Int>,
    callback: @escaping (_ response: Response<T>) -> Void)
    -> (_ response: Response<Data>, _ queue: OperationQueue) throws -> Void
{
    return { (response, queue) in
        guard responseCodes.contains(response.statusCode) else {
            if successCallback {
                throw ResponseError(response: response)
            }
            return
        }
        let newResponse = try Response<T>(response)
        queue.addOperation {
            callback(newResponse)
        }
    }
}
