//
//  NSURLSessionTask+Extensions.swift
//  Request
//
//  Created by Bradley Hilton on 5/18/16.
//  Copyright © 2016 Brad Hilton. All rights reserved.
//

import AssociatedValues

extension NSURLSessionTask {
    
    internal var context: TaskContext {
        get {
            return getAssociatedValueForProperty("taskContext", ofObject: self) ?? TaskContext()
        }
        set {
            setAssociatedValue(newValue, forProperty: "taskContext", ofObject: self)
        }
    }
    
}
