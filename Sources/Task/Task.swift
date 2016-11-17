//
//  Task.swift
//  August
//
//  Created by Bradley Hilton on 5/18/16.
//  Copyright © 2016 Brad Hilton. All rights reserved.
//

import AssociatedValues

open class Task : Equatable {
    
    open internal(set) var request: Request
    var task: URLSessionTask?
    var body = Data()
    var errors = [Error]()
    var timer = August.Timer()

    init(request: Request) {
        self.request = request
        augustQueue.addOperation {
            do {
                self.task = try self.request.task()
                self.task?.parent = self
                self.request.session.tasks.append(self)
            } catch {
                self.start()
                self.handleError(error)
                self.complete(nil)
            }
        }
    }
    
    func start() {
        request.log()
        request.reportStart(self)
        request.reportProgress(self)
    }
    
    func handleError(_ error: Error) {
        errors.append(error)
        request.reportFailure(error, request: request)
        request.failureCallback = nil
        request.reportError(error, request: request)
    }
    
    func complete(_ response: Response<Data>?) {
        if let response = response {
            for error in request.reportResponse(response) {
                handleError(error)
            }
        }
        request.reportCompletion(response, errors: errors, request: request)
    }
    
    open internal(set) var sent = 0.0 { didSet { if oldValue != sent { request.reportProgress(self) } } }
    open internal(set) var received = 0.0 { didSet { if oldValue != received { request.reportProgress(self) } } }
    
    open var state: URLSessionTask.State {
        return task?.state ?? .completed
    }
    
    open func cancel() {
        augustQueue.addOperation {
            self.task?.cancel()
        }
    }
    
    open func suspend() {
        augustQueue.addOperation {
            self.timer.suspend()
            self.task?.suspend()
        }
    }
    
    private var started = false
    
    open func resume() {
        augustQueue.addOperation {
            self.timer.resume()
            guard !self.started else { self.task?.resume(); return }
            self.started = true
            self.start()
            if self.state == .suspended {
                self.task?.resume()
            }
        }
    }
    
}

public func ==(lhs: Task, rhs: Task) -> Bool {
    return lhs === rhs
}

extension URLSessionTask {
    
    weak var parent: Task? {
        get {
            return getAssociatedValue(key: "parent", object: self)
        }
        set {
            set(weakAssociatedValue: newValue, key: "parent", object: self)
        }
    }
    
}


