//
//  Request+Callbacks.swift
//  August
//
//  Created by Bradley Hilton on 5/19/16.
//  Copyright © 2016 Brad Hilton. All rights reserved.
//

extension Request {
    
    public mutating func start(callback callback: StartCallback) {
        startCallbacks.append(callback)
    }
    
    public mutating func progress(callback callback: ProgressCallback) {
        progressCallbacks.append(callback)
    }
    
    public mutating func response<T : DataInitializable>(responseCodes: ResponseCodes..., callback: (response: Response<T>) -> Void) {
        response(reduceResponseCodes(responseCodes), callback: callback)
    }
    
    public mutating func response(responseCodes: ResponseCodes..., callback: (response: Response<NSData>) -> Void) {
        response(reduceResponseCodes(responseCodes), callback: callback)
    }
    
    internal mutating func response<T : DataInitializable>(responseCodes: Set<Int>, callback: (response: Response<T>) -> Void) {
        responseCallbacks.append(ResponseCallback(responseCodes: responseCodes, callback: callback))
    }
    
    public mutating func error<T : ErrorType>(callback callback: (error: T, request: Request) -> Void) {
        errorCallbacks.append(ErrorCallback(callback: callback))
    }
    
    public mutating func error(callback callback: (error: ErrorType, request: Request) -> Void) {
        errorCallbacks.append(ErrorCallback(callback: callback))
    }
    
    public mutating func completion(callback callback: CompletionCallback) {
        completionCallbacks.append(callback)
    }
    
    public mutating func success<T : DataInitializable>(responseCodes: ResponseCodes..., callback: ((response: Response<T>) -> Void)?) {
        success(reduceSuccessCodes(responseCodes), callback: callback)
    }
    
    public mutating func success(responseCodes: ResponseCodes..., callback: ((response: Response<NSData>) -> Void)?) {
        success(reduceSuccessCodes(responseCodes), callback: callback)
    }
    
    internal mutating func success<T : DataInitializable>(responseCodes: Set<Int>, callback: ((response: Response<T>) -> Void)?) {
        if let callback = callback {
            successCallback = SuccessCallback(responseCodes: responseCodes, callback: callback)
        } else {
            successCallback = nil
        }
    }
    
    public mutating func failure(callback callback: FailureCallback?) -> Void {
        failureCallback = callback
    }
    
}

func reduceResponseCodes(codes: [ResponseCodes]) -> Set<Int> {
    return codes.reduce(Set<Int>()) { $0.union($1.responseCodes) }
}

func reduceSuccessCodes(codes: [ResponseCodes]) -> Set<Int> {
    return codes.count == 0 ? (200..<300).responseCodes : reduceResponseCodes(codes)
}
