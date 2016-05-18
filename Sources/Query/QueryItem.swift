//
//  QueryItem.swift
//  Request
//
//  Created by Bradley Hilton on 2/5/16.
//  Copyright © 2016 Brad Hilton. All rights reserved.
//

public struct QueryItem {
    public var name: String
    public var value: QueryValueSerializable?
    public init(name: String, value: QueryValueSerializable?) {
        self.name = name
        self.value = value
    }
}