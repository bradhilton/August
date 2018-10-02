//
//  Session.swift
//  Request
//
//  Created by Bradley Hilton on 5/18/16.
//  Copyright © 2016 Brad Hilton. All rights reserved.
//

import AssociatedValues

let augustQueue: OperationQueue = {
    let queue = OperationQueue()
    queue.maxConcurrentOperationCount = 1
    return queue
}()

open class Session {
    
    public static let sharedSession = Session()
    
    internal let session: URLSession
    internal let maximumSimultaneousTasks: Int?
    internal var tasks: [Task] = [] {
        didSet {
            tasks = tasks.filter { $0.state != .completed }
            if let maximumSimultaneousTasks = maximumSimultaneousTasks, tasks.count > maximumSimultaneousTasks {
                for (index, task) in tasks.enumerated() where index < maximumSimultaneousTasks && task.state == .suspended {
                    task.resume()
                }
            } else {
                for task in tasks where task.state == .suspended {
                    task.resume()
                }
            }
        }
    }

    
    public init(configuration: Configuration = Configuration(.default)) {
        self.maximumSimultaneousTasks = configuration.maximumSimultaneousTasks
        self.session = URLSession(configuration: configuration.foundationConfiguration, delegate: SessionDelegate(), delegateQueue: augustQueue)
        self.session.parent = self
    }
    
    open func finishTasksAndInvalidate() {
        session.finishTasksAndInvalidate()
    }

    open func invalidateAndCancel() {
        session.invalidateAndCancel()
    }
    
    open func reset() {
        session.reset(completionHandler: {})
    }
    
    open func flush() {
        session.flush(completionHandler: {})
    }

    internal var challengeCallback: ChallengeCallback?
    
    open func challenge(callback: ChallengeCallback?) -> Void {
        challengeCallback = callback
    }
    
}

extension URLSession {
    
    weak var parent: Session? {
        get {
            return getAssociatedValue(key: "parent", object: self)
        }
        set {
            set(weakAssociatedValue: newValue, key: "parent", object: self)
        }
    }
    
}
