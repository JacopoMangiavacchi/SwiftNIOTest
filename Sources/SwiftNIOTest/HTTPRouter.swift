//
//  HTTPRouter.swift
//  SwiftNIOTest
//
//  Created by Jacopo Mangiavacchi on 3/1/18.
//

import Foundation

public protocol Responder {
    func respond() -> String
}

public struct RouteResponder<T>: Responder where T: Encodable
{
    public typealias Handler = () -> T
    
    /// The stored responder closure.
    public let handler: Handler
    
    /// Create a new basic responder.
    public init(handler: @escaping Handler) {
        self.handler = handler
    }
    
    /// See: HTTP.Responder.respond
    public func respond() -> String {
        let encodable = handler()
        let data = try! JSONEncoder().encode(encodable)
        return String(data: data, encoding: .utf8)!
    }
}



class HTTPRouter {
    var routingTable = [String : Responder]()
    
    func get<T: Encodable>(_ route: String, handler: @escaping () -> T) {
        let rr = RouteResponder<T>(handler: handler)
        routingTable[route] = rr
    }
}
