//
//  Configuration.swift
//  Request
//
//  Created by Bradley Hilton on 2/5/16.
//  Copyright © 2016 Brad Hilton. All rights reserved.
//

public struct Configuration {
    
    public enum Type {
        case Default
        case Ephemeral
        private var configuration: NSURLSessionConfiguration {
            switch self {
            case .Default: return NSURLSessionConfiguration.defaultSessionConfiguration()
            case .Ephemeral: return NSURLSessionConfiguration.ephemeralSessionConfiguration()
//            case .Background(identifier: let identifier): return NSURLSessionConfiguration.backgroundSessionConfigurationWithIdentifier(identifier)
            }
        }
    }
    
    internal let type: Type
//    public let identifier: String?
    public var cachePolicy: NSURLRequestCachePolicy
    public var timeoutInterval: NSTimeInterval
//    public var timeoutIntervalForResource: NSTimeInterval
    public var networkServiceType: NSURLRequestNetworkServiceType
    public var allowsCellularAccess: Bool
//    public var discretionary: Bool
//    public var sharedContainerIdentifier: String?
//    public var sessionSendsLaunchEvents: Bool
    public var connectionProxyDictionary: [NSObject : AnyObject]?
    public var TLSMinimumSupportedProtocol: SSLProtocol
    public var TLSMaximumSupportedProtocol: SSLProtocol
    public var shouldUsePipelining: Bool
    public var shouldSetCookies: Bool
    public var cookieAcceptPolicy: NSHTTPCookieAcceptPolicy
    public var additionalHeaders: [String : String]?
    public var maximumConnectionsPerHost: Int
//    public var maximumSimultaneousTasks: Int? // TODO: Custom property to limit number of simultaneous tasks
    public var cookieStorage: NSHTTPCookieStorage?
    public var credentialStorage: NSURLCredentialStorage?
    public var cache: NSURLCache?
//    public var shouldUseExtendedBackgroundIdleMode: Bool
    public var protocolClasses: [AnyClass]?
    
    public init(_ type: Type) {
        self.type = type
        let configuration = self.type.configuration
//        identifier = configuration.identifier
        cachePolicy = configuration.requestCachePolicy
        timeoutInterval = configuration.timeoutIntervalForRequest
//        timeoutIntervalForResource = configuration.timeoutIntervalForResource
        networkServiceType = configuration.networkServiceType
        allowsCellularAccess = configuration.allowsCellularAccess
//        discretionary = configuration.discretionary
//        sharedContainerIdentifier = configuration.sharedContainerIdentifier
//        sessionSendsLaunchEvents = configuration.sessionSendsLaunchEvents
        connectionProxyDictionary = configuration.connectionProxyDictionary
        TLSMinimumSupportedProtocol = configuration.TLSMinimumSupportedProtocol
        TLSMaximumSupportedProtocol = configuration.TLSMaximumSupportedProtocol
        shouldUsePipelining = configuration.HTTPShouldUsePipelining
        shouldSetCookies = configuration.HTTPShouldSetCookies
        cookieAcceptPolicy = configuration.HTTPCookieAcceptPolicy
        additionalHeaders = configuration.HTTPAdditionalHeaders?.reduce([String:String]()) { (dictionary, headers: (key: NSObject, value: AnyObject)) in
            var copy = dictionary
            if let key = headers.key as? String {
                copy[key] = headers.value as? String
            }
            return copy
        }
        maximumConnectionsPerHost = configuration.HTTPMaximumConnectionsPerHost
        cookieStorage = configuration.HTTPCookieStorage
        credentialStorage = configuration.URLCredentialStorage
        cache = configuration.URLCache
//        shouldUseExtendedBackgroundIdleMode = configuration.shouldUseExtendedBackgroundIdleMode
        protocolClasses = configuration.protocolClasses
    }
    
    public init() {
        self.init(.Default)
    }
    
    public var foundationConfiguration: NSURLSessionConfiguration {
        let configuration = type.configuration
        configuration.requestCachePolicy = cachePolicy
        configuration.timeoutIntervalForRequest = timeoutInterval
//        configuration.timeoutIntervalForResource = timeoutIntervalForResource
        configuration.networkServiceType = networkServiceType
        configuration.allowsCellularAccess = allowsCellularAccess
//        configuration.discretionary = discretionary
//        configuration.sharedContainerIdentifier = sharedContainerIdentifier
//        configuration.sessionSendsLaunchEvents = sessionSendsLaunchEvents
        configuration.connectionProxyDictionary = connectionProxyDictionary
        configuration.TLSMinimumSupportedProtocol = TLSMinimumSupportedProtocol
        configuration.TLSMaximumSupportedProtocol = TLSMaximumSupportedProtocol
        configuration.HTTPShouldUsePipelining = shouldUsePipelining
        configuration.HTTPShouldSetCookies = shouldSetCookies
        configuration.HTTPCookieAcceptPolicy = cookieAcceptPolicy
        configuration.HTTPAdditionalHeaders = additionalHeaders?.reduce([NSObject:AnyObject]()) { var headers = $0; headers[$1.0] = $1.1; return headers }
        configuration.HTTPMaximumConnectionsPerHost = maximumConnectionsPerHost
        configuration.HTTPCookieStorage = cookieStorage
        configuration.URLCredentialStorage = credentialStorage
        configuration.URLCache = cache
//        configuration.shouldUseExtendedBackgroundIdleMode = shouldUseExtendedBackgroundIdleMode
        configuration.protocolClasses = protocolClasses
        return configuration
    }
    
}
