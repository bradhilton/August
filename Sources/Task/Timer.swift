//
//  Timer.swift
//  August
//
//  Created by Bradley Hilton on 5/20/16.
//  Copyright © 2016 Brad Hilton. All rights reserved.
//

struct Timer {

    var time: TimeInterval {
        guard let timestamp = timestamp else { return allotedTime }
        return allotedTime + Date().timeIntervalSince(timestamp)
    }
    
    var allotedTime: TimeInterval = 0
    var timestamp: Date?
    
    mutating func resume() {
        timestamp = timestamp ?? Date()
    }
    
    mutating func suspend() {
        allotedTime = time
        timestamp = nil
    }
    
}
