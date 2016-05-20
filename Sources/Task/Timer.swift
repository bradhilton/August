//
//  Timer.swift
//  August
//
//  Created by Bradley Hilton on 5/20/16.
//  Copyright © 2016 Brad Hilton. All rights reserved.
//

struct Timer {
    
    var time: NSTimeInterval {
        guard let timestamp = timestamp else { return allotedTime }
        return allotedTime + NSDate().timeIntervalSinceDate(timestamp)
    }
    
    private var allotedTime: NSTimeInterval = 0
    private var timestamp: NSDate?
    
    mutating func resume() {
        guard timestamp == nil else { return }
        timestamp = NSDate()
    }
    
    mutating func suspend() {
        allotedTime = time
        timestamp = nil
    }
    
}
