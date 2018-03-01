//
//  Request+Callbacks+Extensions.swift
//  August
//
//  Created by Bradley Hilton on 11/17/16.
//  Copyright © 2016 Brad Hilton. All rights reserved.
//

extension Request {
    
    public mutating func start(callback: @escaping StartCallback) {
        startCallbacks.append(callback)
    }
    
    public mutating func progress(callback: @escaping ProgressCallback) {
        progressCallbacks.append(callback)
    }
    
    public mutating func response<T>(_ responseCodes: ResponseCodes..., callback: @escaping (_ response: Response<T>) -> Void) {
        addResponse(reduceResponseCodes(responseCodes), callback: callback)
    }
    
    public mutating func response(_ responseCodes: ResponseCodes..., callback: @escaping (_ response: Response<Data>) -> Void) {
        addResponse(reduceResponseCodes(responseCodes), callback: callback)
    }
    
    internal mutating func addResponse<T>(_ responseCodes: Set<Int>, callback: @escaping (_ response: Response<T>) -> Void) {
        responseCallbacks.append(ResponseCallback(responseCodes: responseCodes, callback: callback))
    }
    
    public mutating func error<T : Error>(callback: @escaping (_ error: T, _ request: Request) -> Void) {
        errorCallbacks.append(ErrorCallback(callback: callback))
    }
    
    public mutating func error(callback: @escaping (_ error: Error, _ request: Request) -> Void) {
        errorCallbacks.append(ErrorCallback(callback: callback))
    }
    
    public mutating func completion(callback: @escaping CompletionCallback) {
        completionCallbacks.append(callback)
    }
    
    public mutating func success<T>(_ responseCodes: ResponseCodes..., callback: ((_ response: Response<T>) -> Void)?) {
        success(reduceSuccessCodes(responseCodes), callback: callback)
    }
    
    public mutating func success(_ responseCodes: ResponseCodes..., callback: ((_ response: Response<Data>) -> Void)?) {
        success(reduceSuccessCodes(responseCodes), callback: callback)
    }
    
    internal mutating func success<T>(_ responseCodes: Set<Int>, callback: ((_ response: Response<T>) -> Void)?) {
        if let callback = callback {
            successCallback = SuccessCallback(responseCodes: responseCodes, callback: callback)
        } else {
            successCallback = nil
        }
    }
    
    public mutating func failure(callback: FailureCallback?) -> Void {
        failureCallback = callback
    }
    
}

func reduceResponseCodes(_ codes: [ResponseCodes]) -> Set<Int> {
    return codes.reduce(Set<Int>()) { $0.union($1.responseCodes) }
}

func reduceSuccessCodes(_ codes: [ResponseCodes]) -> Set<Int> {
    guard codes.isEmpty else {
        return reduceResponseCodes(codes)
    }
    return Set(200..<300)
}

