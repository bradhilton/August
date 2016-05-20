//
//  Session.swift
//  Request
//
//  Created by Bradley Hilton on 5/18/16.
//  Copyright © 2016 Brad Hilton. All rights reserved.
//

public class Session {
    
    public static let sharedSession = Session()
    
    internal let session: NSURLSession
    internal let maximumSimultaneousTasks: Int?
    internal var tasks: [Task] = [] {
        didSet {
            tasks = tasks.filter { $0.state == .Suspended || $0.state == .Running }
            if let maximumSimultaneousTasks = maximumSimultaneousTasks where tasks.count > maximumSimultaneousTasks {
                for (index, task) in tasks.enumerate() where index < maximumSimultaneousTasks && task.state == .Suspended {
                    task.resume()
                }
            } else {
                for task in tasks where task.state == .Suspended {
                    task.resume()
                }
            }
        }
    }
    
    public init(configuration: Configuration = Configuration(.Default)) {
        self.maximumSimultaneousTasks = configuration.maximumSimultaneousTasks
        self.session = NSURLSession(configuration: configuration.foundationConfiguration, delegate: SessionDelegate(), delegateQueue: NSOperationQueue())
    }
    
    public func finishTasksAndInvalidate() {
        session.finishTasksAndInvalidate()
    }

    public func invalidateAndCancel() {
        session.invalidateAndCancel()
    }
    
    public func reset() {
        session.resetWithCompletionHandler({})
    }
    
    public func flush() {
        session.flushWithCompletionHandler({})
    }
    
}
