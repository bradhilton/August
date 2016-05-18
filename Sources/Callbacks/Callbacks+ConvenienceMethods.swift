//
//  Callbacks+ConvenienceMethods.swift
//  Request
//
//  Created by Bradley Hilton on 2/6/16.
//  Copyright © 2016 Brad Hilton. All rights reserved.
//

extension Callbacks {
    
    public mutating func setStartCallback(identifier: String, callback: StartCallback?) {
        startCallbacks[identifier] = callback
    }
    
    public mutating func setProgressCallback(identifier: String, callback: ProgressCallback?) {
        progressCallbacks[identifier] = callback
    }
    
    public mutating func setResponseCallback<T : DataInitializable>(
        identifier: String,
        responseCodes: Set<Int>,
        callback: ((response: Response<T>, request: Request) -> Void)?) {
            if let callback = callback {
                responseCallbacks[identifier] = ResponseCallback(responseCodes: responseCodes, callback: callback)
            } else {
                responseCallbacks[identifier] = nil
            }
    }
    
    public mutating func setErrorCallback<T : ErrorType>(identifier: String, callback: ((error: T, request: Request) -> Void)?) {
        errorCallbacks[identifier] = callback != nil ? ErrorCallback(callback: callback!) : nil
    }
    
    public mutating func setErrorCallback(identifier: String, callback: ((error: ErrorType, request: Request) -> Void)?) {
        errorCallbacks[identifier] = callback != nil ? ErrorCallback(callback: callback!) : nil
    }
    
    public mutating func setCompletionCallback(identifier: String, callback: CompletionCallback?) {
        completionCallbacks[identifier] = callback
    }
    
    public mutating func setSuccessCallback<T : DataInitializable>(responseCodes: Set<Int>, callback: ((response: Response<T>, request: Request) -> Void)?) {
        if let callback = callback {
            successCallback = SuccessCallback(responseCodes: responseCodes, callback: callback)
        } else {
            successCallback = nil
        }
    }
    
    public mutating func setFailureCallback(callback: FailureCallback?) -> Void {
        failureCallback = callback
    }
    
}
