//
//  main.swift
//  SwiftNIOTest
//
//  Created by Jacopo Mangiavacchi on 3/1/18.
//

import Foundation

struct User : Codable {
    let firstName: String
    let lastName: String
    let id: Int
}

let users = [User(firstName: "John", lastName: "Doe", id: 1),
             User(firstName: "Jane", lastName: "Doe", id: 2)]

let router = Router()

router.get("/users") {
    return users
}

router.get("/user/0") {
    return users[0]
}

let server = Server(host: "::1", port: 8888, with: router)

server.run()

print("Server closed")


