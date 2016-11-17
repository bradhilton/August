//
//  _RequestBuilder+Casting.swift
//  August
//
//  Created by Bradley Hilton on 7/26/16.
//  Copyright © 2016 Brad Hilton. All rights reserved.
//

extension _RequestBuilder {
    
    public func GET<T : DataInitializable>(_ type: T.Type) -> August.GET<T> {
        return August.GET(self)
    }
    
    public func POST<T : DataInitializable>(_ type: T.Type) -> August.POST<T> {
        return August.POST(self)
    }
    
    public func PUT<T : DataInitializable>(_ type: T.Type) -> August.PUT<T> {
        return August.PUT(self)
    }
    
    public func DELETE<T : DataInitializable>(_ type: T.Type) -> August.DELETE<T> {
        return August.DELETE(self)
    }
    
    public func PATCH<T : DataInitializable>(_ type: T.Type) -> August.PATCH<T> {
        return August.PATCH(self)
    }
    
}
