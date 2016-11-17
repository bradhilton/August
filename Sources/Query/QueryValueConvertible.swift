//
//  QueryValueConvertible.swift
//  Request
//
//  Created by Bradley Hilton on 1/21/16.
//  Copyright © 2016 Brad Hilton. All rights reserved.
//

public protocol QueryValueSerializable {
    
    var queryValue: String { get }
    
}

extension QueryValueSerializable {
    
    public var queryValue: String {
        return String(describing: self)
    }
    
}

extension String : QueryValueSerializable {}

extension Array : QueryValueSerializable {
    
    public var queryValue: String {
        return map { element -> String in
            if let element = element as? QueryValueSerializable {
                return element.queryValue
            } else {
                return String(describing: element)
            }
        }.joined(separator: ",")
    }
    
}
