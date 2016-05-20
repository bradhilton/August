//
//  SessionDelegate.swift
//  Request
//
//  Created by Bradley Hilton on 5/18/16.
//  Copyright © 2016 Brad Hilton. All rights reserved.
//

internal class SessionDelegate : NSObject, NSURLSessionDataDelegate {
    
    func URLSession(session: NSURLSession, task: NSURLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        task.parent?.sent = progress(task.countOfBytesSent, expected: task.countOfBytesExpectedToSend)
    }
    
    func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask, didReceiveResponse response: NSURLResponse, completionHandler: (NSURLSessionResponseDisposition) -> Void) {
        dataTask.parent?.sent = 1.0
        completionHandler(.Allow)
    }
    
    func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask, didReceiveData data: NSData) {
        dataTask.parent?.received = progress(dataTask.countOfBytesReceived, expected: dataTask.countOfBytesExpectedToReceive)
        dataTask.parent?.body.appendData(data)
    }
    
    func URLSession(session: NSURLSession, task: NSURLSessionTask, didCompleteWithError error: NSError?) {
        guard let parent = task.parent else { return }
        var response: Response<NSData>?
        do {
            if let error = error { throw error }
            parent.received = 1.0
            response = try Response(task: parent, response: foundationResponse(task))
            response!.log()
            try parent.request.reportSuccess(response!)
        } catch {
            parent.handleError(error)
        }
        parent.complete(response)
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
