//
//  RequestBuilder.swift
//  Request
//
//  Created by Bradley Hilton on 2/6/16.
//  Copyright © 2016 Brad Hilton. All rights reserved.
//

public protocol _RequestBuilder {
    associatedtype ResponseType : DataInitializable
    func create() -> Request
    init(_ request: Request)
}

extension _RequestBuilder {
    
    public init() {
        self.init(Request())
    }
    
    public init(_ url: Url) {
        self.init(Request(url))
    }
    
    public init(_ string: String) {
        self.init(Request(string))
    }
    
    public init<T : DataInitializable, U : _RequestBuilder where U.ResponseType == T>(_ builder: U) {
        self.init(builder.create())
    }
    
    public func modify(handler: (inout Request) -> ()) -> Self {
        var request = self.create()
        handler(&request)
        return Self(request)
    }
    
    public func url(url: Url) -> Self {
        return modify { (inout request: Request) in request.url = url }
    }
    
    public func cachePolicy(cachePolicy: NSURLRequestCachePolicy) -> Self {
        return modify { (inout request: Request) in request.cachePolicy = cachePolicy }
    }
    
    public func timeoutInterval(timeoutInterval: NSTimeInterval) -> Self {
        return modify { (inout request: Request) in request.timeoutInterval = timeoutInterval }
    }
    
    public func mainDocumentUrl(url: Url?) -> Self {
        return modify { (inout request: Request) in request.mainDocumentURL = url }
    }
    
    public func networkServiceType(networkServiceType: NSURLRequestNetworkServiceType) -> Self {
        return modify { (inout request: Request) in request.networkServiceType = networkServiceType }
    }
    
    public func allowsCellularAccess(allowsCellularAccess: Bool) -> Self {
        return modify { (inout request: Request) in request.allowsCellularAccess = allowsCellularAccess }
    }
    
    public func headers(headers: [String : String]?) -> Self {
        return modify { (inout request: Request) in request.headers = headers ?? [:] }
    }
    
    public func shouldHandleCookies(shouldHandleCookies: Bool) -> Self {
        return modify { (inout request: Request) in request.shouldHandleCookies = shouldHandleCookies }
    }
    
    public func shouldUsePipelining(shouldUsePipelining: Bool) -> Self {
        return modify { (inout request: Request) in request.shouldUsePipelining = shouldUsePipelining }
    }
    
    public func appendHeaders(headers: [String : String?]) -> Self {
        return modify { (inout request: Request) in
            for (field, value) in headers {
                request.headers[field] = value
            }
        }
    }
    
    public func body(body: DataSerializable?) -> Self {
        return modify { (inout request: Request) in request.body = body }
    }
    
    public func session(session: Session) -> Self {
        return modify { (inout request: Request) in request.session = session }
    }
    
    public func queue(queue: NSOperationQueue) -> Self {
        return modify { (inout request: Request) in request.queue = queue }
    }
    
    public func options(options: [ConvertibleOption]) -> Self {
        return modify { (inout request: Request) in request.options = options }
    }
    
    public func logging(logging: Bool) -> Self {
        return modify { (inout request: Request) in request.logging = logging }
    }
    
    public func begin() -> Task {
        return create().begin()
    }
    
}
