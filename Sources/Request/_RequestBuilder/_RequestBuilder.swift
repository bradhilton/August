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
    
    public init<T, U : _RequestBuilder>(_ builder: U) where U.ResponseType == T {
        self.init(builder.create())
    }
    
    public func modify(_ handler: (inout Request) -> ()) -> Self {
        var request = self.create()
        handler(&request)
        return Self(request)
    }
    
    public func url(_ url: Url) -> Self {
        return modify { (request: inout Request) in request.url = url }
    }
    
    public func cachePolicy(_ cachePolicy: URLRequest.CachePolicy) -> Self {
        return modify { (request: inout Request) in request.cachePolicy = cachePolicy }
    }
    
    public func timeoutInterval(_ timeoutInterval: TimeInterval) -> Self {
        return modify { (request: inout Request) in request.timeoutInterval = timeoutInterval }
    }
    
    public func mainDocumentUrl(_ url: Url?) -> Self {
        return modify { (request: inout Request) in request.mainDocumentURL = url }
    }
    
    public func networkServiceType(_ networkServiceType: URLRequest.NetworkServiceType) -> Self {
        return modify { (request: inout Request) in request.networkServiceType = networkServiceType }
    }
    
    public func allowsCellularAccess(_ allowsCellularAccess: Bool) -> Self {
        return modify { (request: inout Request) in request.allowsCellularAccess = allowsCellularAccess }
    }
    
    public func headers(_ headers: [String : String]?) -> Self {
        return modify { (request: inout Request) in request.headers = headers ?? [:] }
    }
    
    public func shouldHandleCookies(_ shouldHandleCookies: Bool) -> Self {
        return modify { (request: inout Request) in request.shouldHandleCookies = shouldHandleCookies }
    }
    
    public func shouldUsePipelining(_ shouldUsePipelining: Bool) -> Self {
        return modify { (request: inout Request) in request.shouldUsePipelining = shouldUsePipelining }
    }
    
    public func appendHeaders(_ headers: [String : String?]) -> Self {
        return modify { (request: inout Request) in
            for (field, value) in headers {
                request.headers[field] = value
            }
        }
    }
    
    public func body(_ body: DataSerializable?) -> Self {
        return modify { (request: inout Request) in request.body = body }
    }
    
    public func session(_ session: Session) -> Self {
        return modify { (request: inout Request) in request.session = session }
    }
    
    public func options(_ options: [ConvertibleOption]) -> Self {
        return modify { (request: inout Request) in request.options = options }
    }
    
    public func logging(_ logging: Bool) -> Self {
        return modify { (request: inout Request) in request.logging = logging }
    }
    
    public func delay(_ delay: TimeInterval) -> Self {
        return modify { (request: inout Request) in request.delay = delay }
    }
    
    public func queue(_ queue: OperationQueue) -> Self {
        return modify { (request: inout Request) in request.queue = queue }
    }
    
    @discardableResult
    public func begin() -> Task {
        return create().begin()
    }
    
}
