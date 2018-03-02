//
//  HTTPHandler.swift
//  SwiftNIOTest
//
//  Created by Jacopo Mangiavacchi on 3/1/18.
//

import Foundation
import NIO
import NIOHTTP1

class HTTPHandler: ChannelInboundHandler {
    private enum FileIOMethod {
        case sendfile
        case nonblockingFileIO
    }
    public typealias InboundIn = HTTPServerRequestPart
    public typealias OutboundOut = HTTPServerResponsePart
    
    private var keepAlive = false
    
    private var handler: ((ChannelHandlerContext, HTTPServerRequestPart) -> Void)? = nil
    private var handlerFuture: EventLoopFuture<()>?
    private let fileIO: NonBlockingFileIO
    
    public init(fileIO: NonBlockingFileIO) {
        self.fileIO = fileIO
    }
    
    func channelRead(ctx: ChannelHandlerContext, data: NIOAny) {
        let reqPart = self.unwrapInboundIn(data)
        if let handler = self.handler {
            handler(ctx, reqPart)
            return
        }
        
        switch reqPart {
        case .head(let request):
            keepAlive = request.isKeepAlive
            
            var responseHead = HTTPResponseHead(version: request.version, status: HTTPResponseStatus.ok)
            responseHead.headers.add(name: "content-length", value: "20")
            let response = HTTPServerResponsePart.head(responseHead)
            ctx.write(self.wrapOutboundOut(response), promise: nil)
        case .body:
            break
        case .end:
            var buffer = ctx.channel.allocator.buffer(capacity: 20)
            buffer.write(staticString: "Hello Swift World!!!")
            
            let content = HTTPServerResponsePart.body(.byteBuffer(buffer.slice()))
            ctx.write(self.wrapOutboundOut(content), promise: nil)
            
            if keepAlive {
                ctx.write(self.wrapOutboundOut(HTTPServerResponsePart.end(nil)), promise: nil)
            } else {
                ctx.write(self.wrapOutboundOut(HTTPServerResponsePart.end(nil))).whenComplete {
                    ctx.close(promise: nil)
                }
            }
        }
    }
    
    func channelReadComplete(ctx: ChannelHandlerContext) {
        ctx.flush()
    }
    
    //    func handlerAdded(ctx: ChannelHandlerContext) {
    //    }
}
