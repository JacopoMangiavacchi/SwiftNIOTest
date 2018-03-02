//
//  HTTPRouter.swift
//  SwiftNIOTest
//
//  Created by Jacopo Mangiavacchi on 3/1/18.
//

import Foundation

class HTTPRouter {
    var routingTable = [String : () -> String]()
    
    func get(_ route: String, handler: @escaping () -> String) {
        routingTable[route] = handler
    }
}
