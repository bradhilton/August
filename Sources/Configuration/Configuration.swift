//
//  Configuration.swift
//  Request
//
//  Created by Bradley Hilton on 2/5/16.
//  Copyright © 2016 Brad Hilton. All rights reserved.
//

public struct Configuration {
    
    public enum `Type` {
        case `default`
        case ephemeral
        fileprivate var configuration: URLSessionConfiguration {
            switch self {
            case .default: return URLSessionConfiguration.default
            case .ephemeral: return URLSessionConfiguration.ephemeral
//            case .Background(identifier: let identifier): return NSURLSessionConfiguration.backgroundSessionConfigurationWithIdentifier(identifier)
            }
        }
    }
    
    internal let type: Type
//    public let identifier: String?
    public var cachePolicy: URLRequest.CachePolicy
    public var timeoutInterval: TimeInterval
//    public var timeoutIntervalForResource: NSTimeInterval
    public var networkServiceType: URLRequest.NetworkServiceType
    public var allowsCellularAccess: Bool
//    public var discretionary: Bool
//    public var sharedContainerIdentifier: String?
//    public var sessionSendsLaunchEvents: Bool
    public var connectionProxyDictionary: [AnyHashable: Any]?
    public var TLSMinimumSupportedProtocol: SSLProtocol
    public var TLSMaximumSupportedProtocol: SSLProtocol
    public var shouldUsePipelining: Bool
    public var shouldSetCookies: Bool
    public var cookieAcceptPolicy: HTTPCookie.AcceptPolicy
    public var additionalHeaders: [String : String]?
    public var maximumConnectionsPerHost: Int
    public var maximumSimultaneousTasks: Int?
    public var cookieStorage: HTTPCookieStorage?
    public var credentialStorage: URLCredentialStorage?
    public var cache: URLCache?
//    public var shouldUseExtendedBackgroundIdleMode: Bool
    public var protocolClasses: [AnyClass]?
    
    public init(_ type: Type = .default) {
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
        TLSMinimumSupportedProtocol = configuration.tlsMinimumSupportedProtocol
        TLSMaximumSupportedProtocol = configuration.tlsMaximumSupportedProtocol
        shouldUsePipelining = configuration.httpShouldUsePipelining
        shouldSetCookies = configuration.httpShouldSetCookies
        cookieAcceptPolicy = configuration.httpCookieAcceptPolicy
        additionalHeaders = configuration.httpAdditionalHeaders?.reduce([String:String]()) { (dictionary, headers: (key: AnyHashable, value: Any)) in
            var copy = dictionary
            if let key = headers.key as? String {
                copy[key] = headers.value as? String
            }
            return copy
        }
        maximumConnectionsPerHost = configuration.httpMaximumConnectionsPerHost
        cookieStorage = configuration.httpCookieStorage
        credentialStorage = configuration.urlCredentialStorage
        cache = configuration.urlCache
//        shouldUseExtendedBackgroundIdleMode = configuration.shouldUseExtendedBackgroundIdleMode
        protocolClasses = configuration.protocolClasses
    }
    
    internal var foundationConfiguration: URLSessionConfiguration {
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
        configuration.tlsMinimumSupportedProtocol = TLSMinimumSupportedProtocol
        configuration.tlsMaximumSupportedProtocol = TLSMaximumSupportedProtocol
        configuration.httpShouldUsePipelining = shouldUsePipelining
        configuration.httpShouldSetCookies = shouldSetCookies
        configuration.httpCookieAcceptPolicy = cookieAcceptPolicy
        configuration.httpAdditionalHeaders = additionalHeaders?.reduce([String:String]()) { var headers = $0; headers[$1.0] = $1.1; return headers }
        configuration.httpMaximumConnectionsPerHost = maximumConnectionsPerHost
        configuration.httpCookieStorage = cookieStorage
        configuration.urlCredentialStorage = credentialStorage
        configuration.urlCache = cache
//        configuration.shouldUseExtendedBackgroundIdleMode = shouldUseExtendedBackgroundIdleMode
        configuration.protocolClasses = protocolClasses
        return configuration
        
    }
    
}
