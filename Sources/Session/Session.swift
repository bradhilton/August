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
    
    public init(configuration: Configuration = Configuration(.Default)) {
        self.session = NSURLSession(configuration: configuration.foundationConfiguration, delegate: SessionDelegate(), delegateQueue: NSOperationQueue())
    }
    
}
