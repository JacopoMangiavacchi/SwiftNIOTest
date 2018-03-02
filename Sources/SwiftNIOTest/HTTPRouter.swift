//
//  HTTPRouter.swift
//  SwiftNIOTest
//
//  Created by Jacopo Mangiavacchi on 3/1/18.
//

import Foundation

enum RequestError : Error {
    //add errors
}


class HTTPRouter {
    typealias CodableArrayClosure<T> = (([T]?, RequestError?) -> Void ) -> Void
    
    func get<T: Codable>(_ route: String, handler: @escaping CodableArrayClosure<T>) {
        
    }
}
