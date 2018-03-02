//
//  main.swift
//  SwiftNIOTest
//
//  Created by Jacopo Mangiavacchi on 3/1/18.
//

import Foundation
import NIO
import NIOHTTP1


let server = HTTPServer(host: "::1", port: 8888)

server.start()

print("Server closed")


