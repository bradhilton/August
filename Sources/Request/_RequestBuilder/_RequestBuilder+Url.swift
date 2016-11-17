//
//  Request+UrlBuilder.swift
//  Request
//
//  Created by Bradley Hilton on 1/21/16.
//  Copyright © 2016 Brad Hilton. All rights reserved.
//

extension _RequestBuilder {
    
    fileprivate func modify(_ handler: (inout Url) -> ()) -> Self {
        return modify { (request: inout Request) in handler(&request.url) }
    }
    
    public func url(_ string: String) -> Self {
        return modify { (url: inout Url) in url = Url(string) }
    }
    
    public func scheme(_ scheme: String?) -> Self {
        return modify { (url: inout Url) in url.scheme = scheme }
    }

    public func user(_ user: String?) -> Self {
        return modify { (url: inout Url) in url.user = user }
    }

    public func password(_ password: String?) -> Self {
        return modify { (url: inout Url) in url.password = password }
    }

    public func host(_ host: String?) -> Self {
        return modify { (url: inout Url) in url.host = host }
    }
    
    public func port(_ port: Int?) -> Self {
        return modify { (url: inout Url) in url.port = port }
    }

    public func path(_ path: String) -> Self {
        return modify { (url: inout Url) in url.path = path }
    }
    
    public func appendPath(_ path: String) -> Self {
        return modify { (url: inout Url) in url.path += path }
    }
    
    public func query(_ query: String?) -> Self {
        return modify { (url: inout Url) in url.query = query }
    }
    
    public func appendQuery(_ query: String) -> Self {
        return modify { (url: inout Url) in
            if let originalQuery = url.query, !originalQuery.isEmpty {
                url.query = "\(originalQuery)&\(query)"
            } else {
                url.query = query
            }
        }
    }
    
    public func queryItems(_ queryItems: QueryItems?) -> Self {
        return modify { (url: inout Url) in url.queryItems = queryItems?.items }
    }

    public func appendQueryItems(_ queryItems: QueryItems) -> Self {
        return modify { (url: inout Url) in
            if let originalQueryItems = url.queryItems {
                url.queryItems = originalQueryItems + queryItems.items
            } else {
                url.queryItems = queryItems.items
            }
        }
    }
    
    public func fragment(_ fragment: String?) -> Self {
        return modify { (url: inout Url) in url.fragment = fragment }
    }

}
