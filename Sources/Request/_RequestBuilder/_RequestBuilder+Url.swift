//
//  Request+UrlBuilder.swift
//  Request
//
//  Created by Bradley Hilton on 1/21/16.
//  Copyright © 2016 Brad Hilton. All rights reserved.
//

extension _RequestBuilder {
    
    private func modify(handler: (inout Url) -> ()) -> Self {
        return modify { (inout request: Request) in handler(&request.url) }
    }
    
    public func url(string: String) -> Self {
        return modify { (inout url: Url) in url = Url(string) }
    }
    
    public func scheme(scheme: String?) -> Self {
        return modify { (inout url: Url) in url.scheme = scheme }
    }

    public func user(user: String?) -> Self {
        return modify { (inout url: Url) in url.user = user }
    }

    public func password(password: String?) -> Self {
        return modify { (inout url: Url) in url.password = password }
    }

    public func host(host: String?) -> Self {
        return modify { (inout url: Url) in url.host = host }
    }
    
    public func port(port: Int?) -> Self {
        return modify { (inout url: Url) in url.port = port }
    }

    public func path(path: String?) -> Self {
        return modify { (inout url: Url) in url.path = path }
    }
    
    public func appendPath(path: String) -> Self {
        return modify { (inout url: Url) in url.path = url.path != nil ? url.path! + path : path }
    }
    
    public func query(query: String?) -> Self {
        return modify { (inout url: Url) in url.query = query }
    }
    
    public func appendQuery(query: String) -> Self {
        return modify { (inout url: Url) in
            if let originalQuery = url.query where !originalQuery.isEmpty {
                url.query = "\(originalQuery)&\(query)"
            } else {
                url.query = query
            }
        }
    }
    
    public func queryItems(queryItems: QueryItems?) -> Self {
        return modify { (inout url: Url) in url.queryItems = queryItems?.items }
    }

    public func appendQueryItems(queryItems: QueryItems) -> Self {
        return modify { (inout url: Url) in
            if let originalQueryItems = url.queryItems {
                url.queryItems = originalQueryItems + queryItems.items
            } else {
                url.queryItems = queryItems.items
            }
        }
    }
    
    public func fragment(fragment: String?) -> Self {
        return modify { (inout url: Url) in url.fragment = fragment }
    }

}