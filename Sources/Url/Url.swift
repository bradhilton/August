//
//  Url.swift
//  Request
//
//  Created by Bradley Hilton on 2/5/16.
//  Copyright © 2016 Brad Hilton. All rights reserved.
//

public struct Url {
    
    var components: URLComponents {
        return URLComponents(string: string) ?? URLComponents()
    }
    
    mutating func modifyComponents(_ handler: (inout URLComponents) -> Void) {
        var components = self.components
        handler(&components)
        string = components.string ?? string
    }
    
    fileprivate var string: String
    
    public var scheme: String? {
        get {
            return components.scheme
        }
        set {
            modifyComponents { $0.scheme = newValue }
        }
    }
    
    public var user: String? {
        get {
            return components.user
        }
        set {
            modifyComponents { $0.user = newValue }
        }
    }
    
    public var password: String? {
        get {
            return components.password
        }
        set {
            modifyComponents { $0.password = newValue }
        }
    }
    
    public var host: String? {
        get {
            return components.host
        }
        set {
            modifyComponents { $0.host = newValue }
        }
    }
    
    public var port: Int? {
        get {
            return components.port
        }
        set {
            modifyComponents { $0.port = newValue }
        }
    }
    
    public var path: String {
        get {
            return components.path
        }
        set {
            modifyComponents { $0.path = newValue }
        }
    }
    
    public var query: String? {
        get {
            return components.query
        }
        set {
            modifyComponents { $0.query = newValue }
        }
    }
    
    public var queryItems: [QueryItem]? {
        get {
            return components.queryItems?.map { QueryItem(name: $0.name, value: $0.value) }
        }
        set {
            modifyComponents { components in
                components.queryItems = newValue?.map { (URLQueryItem(name: $0.name, value: $0.value?.queryValue)) }
            }
        }
    }
    
    public var fragment: String? {
        get {
            return components.fragment
        }
        set {
            modifyComponents { $0.fragment = newValue }
        }
    }
    
    public init(_ string: String = "") {
        self.string = string
    }
    
}

extension Url : ExpressibleByStringLiteral {
    
    public init(unicodeScalarLiteral value: String) {
        self.string = value
    }

    public init(extendedGraphemeClusterLiteral value: String) {
        self.string = value
    }
    
    public init(stringLiteral value: String) {
        self.string = value
    }
    
}

extension Url : CustomStringConvertible {
    
    public var description: String {
        return string
    }
    
}

extension Url : Equatable {}

public func ==(lhs: Url, rhs: Url) -> Bool {
    return lhs.string == rhs.string
}

extension URL {
    
    internal init?(_ url: Url) {
        self.init(string: url.string)
    }
    
}
