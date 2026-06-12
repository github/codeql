public class A {
  void test1(byte b, char c, short s, int i, long l) {
    long b1 = b << 31; // OK
    long b2 = b << 32; // $ Alert // BAD
    long b3 = b << 33; // $ Alert // BAD
    long b4 = b << 64; // $ Alert // BAD

    long c1 = c << 22; // OK
    long c2 = c << 42; // $ Alert // BAD

    long s1 = s << 22; // OK
    long s2 = s << 42; // $ Alert // BAD

    long i1 = i << 22; // OK
    long i2 = i << 32; // $ Alert // BAD
    long i3 = i << 42; // $ Alert // BAD
    long i4 = i << 64; // $ Alert // BAD
    long i5 = i << 65; // $ Alert // BAD

    long l1 = l << 22; // OK
    long l2 = l << 32; // OK
    long l3 = l << 42; // OK
    long l4 = l << 64; // $ Alert // BAD
    long l5 = l << 65; // $ Alert // BAD
  }

  void test2(Byte b, Character c, Short s, Integer i, Long l) {
    long b1 = b << 31; // OK
    long b2 = b << 32; // $ Alert // BAD
    long b3 = b << 33; // $ Alert // BAD
    long b4 = b << 64; // $ Alert // BAD

    long c1 = c << 22; // OK
    long c2 = c << 42; // $ Alert // BAD

    long s1 = s << 22; // OK
    long s2 = s << 42; // $ Alert // BAD

    long i1 = i << 22; // OK
    long i2 = i << 32; // $ Alert // BAD
    long i3 = i << 42; // $ Alert // BAD
    long i4 = i << 64; // $ Alert // BAD
    long i5 = i << 65; // $ Alert // BAD

    long l1 = l << 22; // OK
    long l2 = l << 32; // OK
    long l3 = l << 42; // OK
    long l4 = l << 64; // $ Alert // BAD
    long l5 = l << 65; // $ Alert // BAD
  }
}
