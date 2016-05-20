//
//  _RequestBuilder+Callbacks.swift
//  Request
//
//  Created by Bradley Hilton on 2/6/16.
//  Copyright © 2016 Brad Hilton. All rights reserved.
//

extension _RequestBuilder {
    
    public func success<T>(codes: ResponseCodes..., callback: ((response: Response<T>) -> Void)?) -> Self {
        return modify { (inout request: Request) in
            request.success(reduceSuccessCodes(codes), callback: callback)
        }
    }
    
    public func success(codes: ResponseCodes..., callback: ((response: Response<ResponseType>) -> Void)?) -> Self {
        return modify { (inout request: Request) in
            request.success(reduceSuccessCodes(codes), callback: callback)
        }
    }
    
    public func failure(callback callback: FailureCallback?) -> Self {
        return modify { (inout request: Request) in request.failure(callback: callback) }
    }
    
    public func response<T>(codes: ResponseCodes..., callback: (response: Response<T>) -> Void) -> Self {
        return modify { (inout request: Request) in request.response(reduceResponseCodes(codes), callback: callback) }
    }
    
    public func response(codes: ResponseCodes..., callback: (response: Response<NSData>) -> Void) -> Self {
        return modify { (inout request: Request) in
            request.response(reduceResponseCodes(codes), callback: callback)
        }
    }
    
    public func start(callback callback: StartCallback) -> Self {
        return modify { (inout request: Request) in
            request.start(callback: callback)
        }
    }

    public func progress(callback callback: ProgressCallback) -> Self {
        return modify { (inout request: Request) in
            request.progress(callback: callback)
        }
    }
    
    public func completion(callback callback: CompletionCallback) -> Self {
        return modify { (inout request: Request) in
            request.completion(callback: callback)
        }
    }
    
    public func error(callback callback: (error: ErrorType, request: Request) -> Void) -> Self {
        return modify { (inout request: Request) in
            request.error(callback: callback)
        }
    }
    
    public func error<T : ErrorType>(callback callback: (error: T, request: Request) -> Void) -> Self {
        return modify { (inout request: Request) in
            request.error(callback: callback)
        }
    }
    
}

