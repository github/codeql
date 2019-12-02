public class E {
  static Object src() { return new Object(); }
  static void sink(Object obj) {}

  static class Buffer { Object content; }
  static class BufHolder { Buffer buf; }
  static class Packet { BufHolder data; }

  static void recv(Buffer buf) {
    buf.content = src();
  }

  static void foo(Buffer raw, BufHolder bh, Packet p) {
    recv(raw);
    recv(bh.buf);
    recv(p.data.buf);

    sink(raw.content);

    BufHolder bh2 = bh;
    sink(bh2.buf.content);

    Packet p2 = p;
    sink(p2.data.buf.content);

    handlepacket(p);
  }

  static void handlepacket(Packet p) {
    sink(p.data.buf.content);
  }
}
