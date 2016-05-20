//
//  Task.swift
//  August
//
//  Created by Bradley Hilton on 5/18/16.
//  Copyright © 2016 Brad Hilton. All rights reserved.
//

import AssociatedValues

public class Task : Equatable {
    
    public internal(set) var request: Request
    var task: NSURLSessionTask?
    let body = NSMutableData()
    var errors = [ErrorType]()
    var timer = Timer()

    init(request: Request) {
        self.request = request
        do {
            self.task = try request.task()
            self.task?.parent = self
            request.session.tasks.append(self)
        } catch {
            start()
            handleError(error)
            complete(nil)
        }
    }
    
    func start() {
        request.reportStart(self)
        request.reportProgress(self)
    }
    
    func handleError(error: ErrorType) {
        errors.append(error)
        request.reportFailure(error, request: request)
        request.failureCallback = nil
        request.reportError(error, request: request)
    }
    
    func complete(response: Response<NSData>?) {
        if let response = response {
            for error in request.reportResponse(response) {
                handleError(error)
            }
        }
        request.reportCompletion(response, errors: errors, request: request)
        if let index = request.session.tasks.indexOf(self) {
            request.session.tasks.removeAtIndex(index)
        }
    }
    
    public internal(set) var sent = 0.0 { didSet { if oldValue != sent { request.reportProgress(self) } } }
    public internal(set) var received = 0.0 { didSet { if oldValue != received { request.reportProgress(self) } } }
    
    public var state: NSURLSessionTaskState {
        return task?.state ?? .Completed
    }
    
    public func cancel() {
        task?.cancel()
    }
    
    public func suspend() {
        timer.suspend()
        task?.suspend()
    }
    
    private var started = false
    
    public func resume() {
        if !started {
            started = true
            start()
        }
        timer.resume()
        task?.resume()
    }
    
}

public func ==(lhs: Task, rhs: Task) -> Bool {
    return lhs === rhs
}

extension NSURLSessionTask {
    
    weak var parent: Task? {
        get {
            return getAssociatedValueForProperty("parent", ofObject: self)
        }
        set {
            setWeakAssociatedValue(newValue, forProperty: "parent", ofObject: self)
        }
    }
    
}


