//
//  Callbacks+Reporting.swift
//  Request
//
//  Created by Bradley Hilton on 2/6/16.
//  Copyright © 2016 Brad Hilton. All rights reserved.
//

extension Callbacks {
    
    internal func reportStart(request: Request) {
        queue.addOperationWithBlock {
            self.startCallbacks.values.forEach { $0(request: request) }
        }
    }
    
    internal func reportProgress(sent: Double, received: Double, request: Request) {
        queue.addOperationWithBlock {
            self.progressCallbacks.values.forEach { $0(sent: sent, received: received, request: request) }
        }
    }
    
    internal func reportResponse(response: Response<NSData>, request: Request) -> [ErrorType] {
        return self.responseCallbacks.values.reduce([ErrorType]()) { (errors, callback) in
            do {
                try callback.callback(response: response, request: request, queue: self.queue)
                return errors
            } catch {
                return errors + [error]
            }
        }
    }
    
    internal func reportSuccess(response: Response<NSData>, request: Request) throws {
        try successCallback?.callback(response: response, request: request, queue: queue)
    }
    
    internal func reportFailure(error: ErrorType, request: Request) {
        queue.addOperationWithBlock {
            self.failureCallback?(error: error, request: request)
        }
    }
    
    internal func reportError(error: ErrorType, request: Request) {
        queue.addOperationWithBlock {
            self.errorCallbacks.values.forEach { $0.callback(error: error, request: request) }
        }
    }
    
    internal func reportCompletion(response: Response<NSData>?, errors: [ErrorType], request: Request) {
        queue.addOperationWithBlock {
            self.completionCallbacks.values.forEach { $0(response: response, errors: errors, request: request) }
        }
    }
    
}