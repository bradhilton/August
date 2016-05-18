//
//  ResponseCodes.swift
//  Request
//
//  Created by Bradley Hilton on 1/21/16.
//  Copyright © 2016 Brad Hilton. All rights reserved.
//

public protocol ResponseCodes {
    
    var responseCodes: Set<Int> { get }
    
}

extension Range : ResponseCodes {
    
    public var responseCodes: Set<Int> {
        guard Element.self is Int.Type else { return Set<Int>() }
        return reduce(Set()) { $0.0.union([$0.1 as! Int]) }
    }
    
}

extension Int : ResponseCodes {
    
    public var responseCodes: Set<Int> {
        return [self]
    }
    
}
