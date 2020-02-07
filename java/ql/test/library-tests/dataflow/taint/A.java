import java.io.*;

public class A {
  byte[] taint() { return new byte[2]; }

  void sink(Object o) { }

  void test1() {
    ByteArrayOutputStream bOutput = new ByteArrayOutputStream();
    bOutput.write(taint(), 0, 1);
    byte[] b = bOutput.toByteArray();
    ByteArrayInputStream bInput = new ByteArrayInputStream(b);
    byte[] b2 = new byte[10];
    bInput.read(b2, 0, 1);
    sink(b2);
  }

  void test2() {
    ByteArrayOutputStream bOutput = new ByteArrayOutputStream();
    bOutput.write(taint());
    byte[] b = bOutput.toByteArray();
    ByteArrayInputStream bInput = new ByteArrayInputStream(b);
    byte[] b2 = new byte[10];
    bInput.read(b2);
    sink(b2);
  }

  void streamWrite(ByteArrayOutputStream baos, byte[] data) {
    baos.write(data);
  }

  void test3(ByteArrayOutputStream baos) {
    streamWrite(baos, taint());
    sink(baos.toByteArray());
  }

  static class BaosHolder {
    ByteArrayOutputStream baos = new ByteArrayOutputStream();
  }

  void streamWriteHolder(BaosHolder bh, byte[] data) {
    bh.baos.write(data);
  }

  void test4(BaosHolder bh) {
    streamWriteHolder(bh, taint());
    sink(bh.baos.toByteArray());
  }

  static class DataHolder {
    byte[] data = new byte[10];
  }

  void test5_a(DataHolder dh) {
    ByteArrayInputStream bais = new ByteArrayInputStream(taint());
    bais.read(dh.data);
    test5_b(dh);
  }

  void test5_b(DataHolder dh) {
    sink(dh.data);
  }

  void arrayWrite(byte[] from, byte[] to) {
    for (int i = 0; i < 10; i++) {
      to[i] = from[i];
    }
  }

  void test6() {
    byte[] b = new byte[10];
    arrayWrite(taint(), b);
    sink(b);
  }
}
