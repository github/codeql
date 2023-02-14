import io.netty.channel.*;
import io.netty.buffer.ByteBuf;
// import io.netty.handler.codec.*;
// import io.netty.handler.codec.http.*;

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
}