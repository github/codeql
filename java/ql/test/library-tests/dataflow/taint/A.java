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
}
