public class Test {

  byte b;
  short s;
  int i;
  long l;
  float f;
  double d;  

  public void test(Number n, Byte b2) {

    b = n.byteValue();
    s = n.shortValue();
    i = n.intValue();
    l = n.longValue();
    f = n.floatValue();
    d = n.doubleValue();
    b = b2.byteValue();
    s = b2.shortValue();
    i = b2.intValue();
    l = b2.longValue();
    f = b2.floatValue();
    d = b2.doubleValue();

  }

}
