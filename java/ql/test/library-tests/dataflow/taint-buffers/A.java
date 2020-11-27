import java.nio.ByteBuffer;
import java.nio.CharBuffer;

class A {
    Object taint() { return null; }

    void sink(Object x) {}

    void test1() {
        byte[] data = (byte[]) taint();

        ByteBuffer buf = ByteBuffer.allocate(1024);

        buf.put(data);
        buf.rewind();

        byte[] data2 = new byte[64];
        buf.get(data2);
        sink(data2);
    }

    void test2() {
        byte[] data = (byte[]) taint();

        ByteBuffer buf = ByteBuffer.wrap(data);

        sink(buf.duplicate().flip().compact().asCharBuffer().array());
    }

    void test3() {
        String text = (String) taint();

        CharBuffer buf = CharBuffer.allocate(1024);
        buf.put(text);

        sink(buf);
    }
}