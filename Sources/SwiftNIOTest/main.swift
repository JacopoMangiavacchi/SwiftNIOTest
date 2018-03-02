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

let users = [User(firstName: "John", lastName: "Doe", id: 1),
             User(firstName: "Jane", lastName: "Doe", id: 2)]

let router = HTTPRouter()

router.get("/users") {
    let data = try! JSONEncoder().encode(users)
    return String(data: data, encoding: .utf8)!
}

router.get("/user:1") {
    let data = try! JSONEncoder().encode(users[0])
    return String(data: data, encoding: .utf8)!
}

let server = HTTPServer(host: "::1", port: 8888, with: router)

server.run()

print("Server closed")


