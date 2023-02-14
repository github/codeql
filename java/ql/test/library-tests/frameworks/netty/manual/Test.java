import io.netty.channel.*;
import io.netty.buffer.ByteBuf;
import io.netty.handler.codec.*;
import io.netty.handler.codec.http.*;
import io.netty.handler.codec.http2.*;

import java.util.List;

class Test {
    static <T> T source() { return null; }
    static void sink(Object s) {}

    class A extends ChannelInboundHandlerAdapter {
        public void channelRead(ChannelHandlerContext ctx, Object msg) {
            sink(msg); // $hasTaintFlow
        }
    }

    class B extends ChannelInboundHandlerAdapter {
        public void channelRead(ChannelHandlerContext ctx, Object msg) {
            ByteBuf bb = (ByteBuf) msg;
            byte[] data = new byte[1024];
            bb.readBytes(data);
            sink(data); // $hasTaintFlow
        }
    }

    void test(ByteBuf bb, byte[] x) {
        byte[] src = source();
        bb.readBytes(x).setLong(3, 4).readerIndex(2).writeBytes(src).skipBytes(2);
        sink(bb); // $ hasTaintFlow
        sink(x);
    }

    class C extends ByteToMessageDecoder {
        public void callDecode(ChannelHandlerContext ctx, ByteBuf msg, List<Object> out) {
            sink(msg); // $ hasTaintFlow
        }

        public void decode(ChannelHandlerContext ctx, ByteBuf msg, List<Object> out) {
            sink(msg); // $ hasTaintFlow
        }

        public void decodeLast(ChannelHandlerContext ctx, ByteBuf msg, List<Object> out) {
            sink(msg); // $ hasTaintFlow
        }
    }

    class D extends SimpleChannelInboundHandler<FullHttpRequest> {
        public void channelRead0(ChannelHandlerContext ctx, FullHttpRequest msg) {
            sink(msg.uri()); // $ hasTaintFlow
            sink(msg.headers().get("X-blah")); // $ hasTaintFlow
            sink(msg.content()); // $ hasTaintFlow
        }
    }

    class E extends Http2FrameAdapter {
        public int onDataRead(ChannelHandlerContext ctx, int streamId, ByteBuf data, int padding, boolean endOfStream) {
            sink(data); // $ hasTaintFlow
            return 0;
        }

        public void onHeadersRead(ChannelHandlerContext ctx, int streamId, Http2Headers headers, int padding, boolean endStream) {
            sink(headers.get("X-blah")); // $ hasTaintFlow
            sink(headers.path()); // $ hasTaintFlow
        }

        public void onPushPromiseRead(ChannelHandlerContext ctx, int streamId, int promisedStreamId, Http2Headers headers, int padding) {
            sink(headers); // $ hasTaintFlow
        }

        public void onUnknownFrame(ChannelHandlerContext ctx, byte frameType, int streamId, Http2Flags flags, ByteBuf payload) {
            sink(payload); // $ hasTaintFlow
        }
    }
}