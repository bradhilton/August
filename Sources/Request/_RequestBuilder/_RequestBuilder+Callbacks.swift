//
//  _RequestBuilder+Callbacks.swift
//  Request
//
//  Created by Bradley Hilton on 2/6/16.
//  Copyright © 2016 Brad Hilton. All rights reserved.
//

private func randomIdentifier() -> String {
    return NSUUID().UUIDString
}

extension _RequestBuilder {
    
    private func modify(handler: (inout Callbacks) -> ()) -> Self {
        return modify { (inout request: Request) in handler(&request.callbacks) }
    }
    
    public func success<T>(codes: ResponseCodes..., callback: ((response: Response<T>, request: Request) -> Void)?) -> Self {
        return modify { (inout callbacks: Callbacks) in
            callbacks.setSuccessCallback(successCodes(codes), callback: callback)
        }
    }
    
    public func success(codes: ResponseCodes..., callback: ((response: Response<ResponseType>, request: Request) -> Void)?) -> Self {
        return modify { (inout callbacks: Callbacks) in
            callbacks.setSuccessCallback(successCodes(codes), callback: callback)
        }
    }
    
    public func failure(callback callback: FailureCallback?) -> Self {
        return modify { (inout callbacks: Callbacks) in callbacks.setFailureCallback(callback) }
    }
    
    public func response<T>(codes: ResponseCodes..., callback: (response: Response<T>, request: Request) -> Void) -> Self {
        return modify { (inout callbacks: Callbacks) in callbacks.setResponseCallback(randomIdentifier(), responseCodes: responseCodes(codes), callback: callback) }
    }
    
    public func response(codes: ResponseCodes..., callback: (response: Response<NSData>, request: Request) -> Void) -> Self {
        return modify { (inout callbacks: Callbacks) in
            callbacks.setResponseCallback(randomIdentifier(), responseCodes: responseCodes(codes), callback: callback)
        }
    }
    
    public func start(callback callback: StartCallback) -> Self {
        return modify { (inout callbacks: Callbacks) in
            callbacks.setStartCallback(randomIdentifier(), callback: callback)
        }
    }

    public func progress(callback callback: ProgressCallback) -> Self {
        return modify { (inout callbacks: Callbacks) in
            callbacks.setProgressCallback(randomIdentifier(), callback: callback)
        }
    }
    
    public func completion(callback callback: CompletionCallback) -> Self {
        return modify { (inout callbacks: Callbacks) in
            callbacks.setCompletionCallback(randomIdentifier(), callback: callback)
        }
    }
    
    public func error(callback callback: (error: ErrorType, request: Request) -> Void) -> Self {
        return modify { (inout callbacks: Callbacks) in
            callbacks.setErrorCallback(randomIdentifier(), callback: callback)
        }
    }
    
    public func error<T : ErrorType>(callback callback: (error: T, request: Request) -> Void) -> Self {
        return modify { (inout callbacks: Callbacks) in
            callbacks.setErrorCallback(randomIdentifier(), callback: callback)
        }
    }
    
}

private func responseCodes(codes: [ResponseCodes]) -> Set<Int> {
    return codes.reduce(Set<Int>()) { $0.union($1.responseCodes) }
}

private func successCodes(codes: [ResponseCodes]) -> Set<Int> {
    return codes.count == 0 ? (200..<300).responseCodes : responseCodes(codes)
}

