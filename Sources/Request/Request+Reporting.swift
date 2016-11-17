//
//  Request+Reporting.swift
//  August
//
//  Created by Bradley Hilton on 5/19/16.
//  Copyright © 2016 Brad Hilton. All rights reserved.
//

extension Request {
    
    internal func reportStart(_ task: Task) {
        queue.addOperation {
            self.startCallbacks.forEach { $0(task) }
        }
    }
    
    internal func reportProgress(_ task: Task) {
        queue.addOperation {
            self.progressCallbacks.forEach { $0(task) }
        }
    }
    
    internal func reportResponse(_ response: Response<Data>) -> [Error] {
        return self.responseCallbacks.reduce([Error]()) { (errors, callback) in
            do {
                try callback.callback(response, self.queue)
                return errors
            } catch {
                return errors + [error]
            }
        }
    }
    
    internal func reportSuccess(_ response: Response<Data>) throws {
        try successCallback?.callback(response, queue)
    }
    
    internal func reportFailure(_ error: Error, request: Request) {
        queue.addOperation {
            self.failureCallback?(error, request)
        }
    }
    
    internal func reportError(_ error: Error, request: Request) {
        queue.addOperation {
            self.errorCallbacks.forEach { $0.callback(error, request) }
        }
    }
    
    internal func reportCompletion(_ response: Response<Data>?, errors: [Error], request: Request) {
        queue.addOperation {
            self.completionCallbacks.forEach { $0(response, errors, request) }
        }
    }
    
}
