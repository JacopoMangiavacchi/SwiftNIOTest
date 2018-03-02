//
//  HTTPHandler.swift
//  SwiftNIOTest
//
//  Created by Jacopo Mangiavacchi on 3/1/18.
//

import Foundation
import NIO
import NIOHTTP1

public class Handler: ChannelInboundHandler {
    private enum FileIOMethod {
        case sendfile
        case nonblockingFileIO
    }
    public typealias InboundIn = HTTPServerRequestPart
    public typealias OutboundOut = HTTPServerResponsePart
    
    private var requestUri: String?
    private var keepAlive = false
    
    private let fileIO: NonBlockingFileIO
    private let router: Router
    
    public init(fileIO: NonBlockingFileIO, router: Router) {
        self.fileIO = fileIO
        self.router = router
    }
    
    public func channelRead(ctx: ChannelHandlerContext, data: NIOAny) {
        let reqPart = self.unwrapInboundIn(data)
        
        switch reqPart {
        case .head(let request):
            keepAlive = request.isKeepAlive
            var buffer: ByteBuffer
            
            if let routerHandler = router.routingTable[request.uri] {
                let responseBody = routerHandler.respond()
                
                buffer = ctx.channel.allocator.buffer(capacity: responseBody.lengthOfBytes(using: String.Encoding.utf8))
                buffer.write(string: responseBody)
            }
            else {
                buffer = ctx.channel.allocator.buffer(capacity: 5)
                buffer.write(staticString: "ERROR")
            }
                
            var responseHead = HTTPResponseHead(version: request.version, status: HTTPResponseStatus.ok)
            responseHead.headers.add(name: "content-length", value: String(buffer.readableBytes))
            let response = HTTPServerResponsePart.head(responseHead)
            ctx.write(self.wrapOutboundOut(response), promise: nil)
            
            let content = HTTPServerResponsePart.body(.byteBuffer(buffer.slice()))
            ctx.write(self.wrapOutboundOut(content), promise: nil)
        case .body:
            break
        case .end:
            if keepAlive {
                ctx.write(self.wrapOutboundOut(HTTPServerResponsePart.end(nil)), promise: nil)
            } else {
                ctx.write(self.wrapOutboundOut(HTTPServerResponsePart.end(nil))).whenComplete {
                    ctx.close(promise: nil)
                }
            }
        }
    }
    
    public func channelReadComplete(ctx: ChannelHandlerContext) {
        ctx.flush()
    }
}
