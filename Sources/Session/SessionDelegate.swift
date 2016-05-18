//
//  SessionDelegate.swift
//  Request
//
//  Created by Bradley Hilton on 5/18/16.
//  Copyright © 2016 Brad Hilton. All rights reserved.
//

internal class SessionDelegate : NSObject, NSURLSessionDataDelegate {
    
    func URLSession(session: NSURLSession, task: NSURLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        task.context.sent = progress(task.countOfBytesSent, expected: task.countOfBytesExpectedToSend)
    }
    
    func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask, didReceiveResponse response: NSURLResponse, completionHandler: (NSURLSessionResponseDisposition) -> Void) {
        dataTask.context.sent = 1.0
        completionHandler(.Allow)
    }
    
    func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask, didReceiveData data: NSData) {
        dataTask.context.received = progress(dataTask.countOfBytesReceived, expected: dataTask.countOfBytesExpectedToReceive)
        dataTask.context.body.appendData(data)
    }
    
    func URLSession(session: NSURLSession, task: NSURLSessionTask, didCompleteWithError error: NSError?) {
        var response: Response<NSData>?
        do {
            if let error = error { throw error }
            task.context.received = 1.0
            let foundationResponse = try self.foundationResponse(task)
            let responseTime = NSDate().timeIntervalSinceDate(task.context.startTime)
            if task.context.request.logging {
                Logging.logResponse(foundationResponse,
                                    request: task.context.request,
                                    responseTime: responseTime,
                                    data: task.context.body)
            }
            response = Response(body: task.context.body as NSData,
                                foundationResponse: foundationResponse,
                                responseTime: responseTime,
                                options: task.context.request.options)
            try task.context.request.callbacks.reportSuccess(response!, request: task.context.request)
        } catch {
            task.context.handleError(error)
        }
        task.context.complete(response)
    }
    
    private func foundationResponse(task: NSURLSessionTask) throws -> NSHTTPURLResponse {
        guard let foundationResponse = task.response as? NSHTTPURLResponse else {
            throw UnknownError(description: "Task did not return NSHTTPURLResponse")
        }
        return foundationResponse
    }
    
    private func progress(actual: Int64, expected: Int64) -> Double {
        return expected != 0 ? Double(actual)/Double(expected) : 1
    }
    
}
