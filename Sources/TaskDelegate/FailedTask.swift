//
//  FailedTask.swift
//  Request
//
//  Created by Bradley Hilton on 1/21/16.
//  Copyright © 2016 Brad Hilton. All rights reserved.
//

internal class FailedTask : NSURLSessionTask {
    override var taskIdentifier: Int { return -1 }
    override var originalRequest: NSURLRequest? { return nil }
    override var currentRequest: NSURLRequest? { return nil }
    override var response: NSHTTPURLResponse? { return nil }
    override var countOfBytesReceived: Int64 { return 0 }
    override var countOfBytesSent: Int64 { return 0 }
    override var countOfBytesExpectedToSend: Int64 { return 0 }
    override var countOfBytesExpectedToReceive: Int64 { return 0 }
    override var taskDescription: String? { get { return nil } set {} }
    override func cancel() {}
    override var state: NSURLSessionTaskState { return .Completed }
    override var error: NSError? { return nil }
    override func suspend() {}
    override func resume() {}
    override var priority: Float { get { return 0 } set {} }
}