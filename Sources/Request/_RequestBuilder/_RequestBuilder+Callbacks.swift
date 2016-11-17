//
//  _RequestBuilder+Callbacks.swift
//  Request
//
//  Created by Bradley Hilton on 2/6/16.
//  Copyright © 2016 Brad Hilton. All rights reserved.
//

extension _RequestBuilder {
    
    public func success<T>(_ codes: ResponseCodes..., callback: ((_ response: Response<T>) -> Void)?) -> Self {
        return modify { (request: inout Request) in
            request.success(reduceSuccessCodes(codes), callback: callback)
        }
    }
    
    public func success(_ codes: ResponseCodes..., callback: ((_ response: Response<ResponseType>) -> Void)?) -> Self {
        return modify { (request: inout Request) in
            request.success(reduceSuccessCodes(codes), callback: callback)
        }
    }
    
    public func failure(callback: FailureCallback?) -> Self {
        return modify { (request: inout Request) in request.failure(callback: callback) }
    }
    
    public func response<T>(_ codes: ResponseCodes..., callback: @escaping (_ response: Response<T>) -> Void) -> Self {
        return modify { (request: inout Request) in request.addResponse(reduceResponseCodes(codes), callback: callback) }
    }
    
    public func response(_ codes: ResponseCodes..., callback: @escaping (_ response: Response<Data>) -> Void) -> Self {
        return modify { (request: inout Request) in
            request.addResponse(reduceResponseCodes(codes), callback: callback)
        }
    }
    
    public func start(callback: @escaping StartCallback) -> Self {
        return modify { (request: inout Request) in
            request.start(callback: callback)
        }
    }

    public func progress(callback: @escaping ProgressCallback) -> Self {
        return modify { (request: inout Request) in
            request.progress(callback: callback)
        }
    }
    
    public func completion(callback: @escaping CompletionCallback) -> Self {
        return modify { (request: inout Request) in
            request.completion(callback: callback)
        }
    }
    
    public func error(callback: @escaping (_ error: Error, _ request: Request) -> Void) -> Self {
        return modify { (request: inout Request) in
            request.error(callback: callback)
        }
    }
    
    public func error<T : Error>(callback: @escaping (_ error: T, _ request: Request) -> Void) -> Self {
        return modify { (request: inout Request) in
            request.error(callback: callback)
        }
    }
    
}

