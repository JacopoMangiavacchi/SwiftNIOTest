//
//  main.swift
//  SwiftNIOTest
//
//  Created by Jacopo Mangiavacchi on 3/1/18.
//

import Foundation
import NIO
import NIOHTTP1


struct User : Codable {
    let firstName: String
    let lastName: String
    let id: Int
}


let router = HTTPRouter()

router.get("/api") { (respondWith: ([User]?, RequestError?) -> Void) in
    let users = [User(firstName: "John", lastName: "Doe", id: 1)]
    respondWith(users, nil)
}

let server = HTTPServer(host: "::1", port: 8888, with: router)

server.run()

print("Server closed")


