//
//  SessionDelegate.swift
//  Request
//
//  Created by Bradley Hilton on 5/18/16.
//  Copyright © 2016 Brad Hilton. All rights reserved.
//

internal class SessionDelegate : NSObject, URLSessionDataDelegate {
    
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        guard let callback = session.parent?.challengeCallback else {
            return completionHandler(.performDefaultHandling, nil)
        }
        let (disposition, credential) = callback(challenge)
        completionHandler(disposition, credential)
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        task.parent?.sent = progress(task.countOfBytesSent, expected: task.countOfBytesExpectedToSend)
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        dataTask.parent?.sent = 1.0
        completionHandler(.allow)
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        dataTask.parent?.received = progress(dataTask.countOfBytesReceived, expected: dataTask.countOfBytesExpectedToReceive)
        dataTask.parent?.body.append(data)
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        guard let parent = task.parent else { return }
        var response: Response<Data>?
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
    
    fileprivate func foundationResponse(_ task: URLSessionTask) throws -> HTTPURLResponse {
        guard let foundationResponse = task.response as? HTTPURLResponse else {
            throw UnknownError(description: "Task did not return NSHTTPURLResponse")
        }
        return foundationResponse
    }
    
    fileprivate func progress(_ actual: Int64, expected: Int64) -> Double {
        return expected != 0 ? Double(actual)/Double(expected) : 1
    }
    
}
