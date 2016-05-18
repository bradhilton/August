//
//  TaskContext.swift
//  August
//
//  Created by Bradley Hilton on 5/18/16.
//  Copyright © 2016 Brad Hilton. All rights reserved.
//

struct TaskContext {
    
    var request = Request()
    let body = NSMutableData()
    var response: Response<NSData>?
    var errors = [ErrorType]()
    var startTime = NSDate()
    var sent = 0.0 { didSet { if oldValue != sent { reportProgress() } } }
    var received = 0.0 { didSet { if oldValue != received { reportProgress() } } }
    
    init(request: Request = Request()) {
        self.request = request
    }
    
    mutating func task() -> NSURLSessionTask {
        request.callbacks.reportStart(request)
        reportProgress()
        do {
            return try startTask(request.foundationRequest())
        } catch {
            return failedTaskWithError(error)
        }
    }
    
    mutating func handleError(error: ErrorType) {
        errors.append(error)
        request.callbacks.reportFailure(error, request: request)
        request.callbacks.failureCallback = nil
        request.callbacks.reportError(error, request: request)
    }
    
    mutating func complete(response: Response<NSData>?) {
        if let response = response {
            for error in request.callbacks.reportResponse(response, request: request) {
                handleError(error)
            }
        }
        request.callbacks.reportCompletion(response, errors: errors, request: request)
    }
    
    private mutating func failedTaskWithError(error: ErrorType) -> NSURLSessionTask {
        handleError(error)
        complete(nil)
        return FailedTask()
    }
    
    private mutating func startTask(foundationRequest: NSURLRequest) -> NSURLSessionTask {
        let task = request.session.session.dataTaskWithRequest(foundationRequest)
        task.resume()
        request.logging ? Logging.logRequest(foundationRequest) : ()
        startTime = NSDate()
        task.context = self
        return task
    }
    
    private func reportProgress() {
        request.callbacks.reportProgress(sent, received: received, request: request)
    }
    
}
