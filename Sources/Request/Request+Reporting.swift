//
//  Request+Reporting.swift
//  August
//
//  Created by Bradley Hilton on 5/19/16.
//  Copyright © 2016 Brad Hilton. All rights reserved.
//

extension Request {
    
    internal func reportStart(task: Task) {
        queue.addOperationWithBlock {
            self.startCallbacks.forEach { $0(task: task) }
        }
    }
    
    internal func reportProgress(task: Task) {
        queue.addOperationWithBlock {
            self.progressCallbacks.forEach { $0(task: task) }
        }
    }
    
    internal func reportResponse(response: Response<NSData>) -> [ErrorType] {
        return self.responseCallbacks.reduce([ErrorType]()) { (errors, callback) in
            do {
                try callback.callback(response: response, queue: self.queue)
                return errors
            } catch {
                return errors + [error]
            }
        }
    }
    
    internal func reportSuccess(response: Response<NSData>) throws {
        try successCallback?.callback(response: response, queue: queue)
    }
    
    internal func reportFailure(error: ErrorType, request: Request) {
        queue.addOperationWithBlock {
            self.failureCallback?(error: error, request: request)
        }
    }
    
    internal func reportError(error: ErrorType, request: Request) {
        queue.addOperationWithBlock {
            self.errorCallbacks.forEach { $0.callback(error: error, request: request) }
        }
    }
    
    internal func reportCompletion(response: Response<NSData>?, errors: [ErrorType], request: Request) {
        queue.addOperationWithBlock {
            self.completionCallbacks.forEach { $0(response: response, errors: errors, request: request) }
        }
    }
    
}
