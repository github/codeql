import java.util.*;

public class A {
  int getInt() {
    return new Object().hashCode();
  }

  void unreachable() { }

  void test(int x, int y) {
    if (x < 3) {
      x++;
      if (x - 1 == 2) return;
      x--;
      if (x >= 2) unreachable(); // useless test
    }

    if (y > 0) {
      int z = (x >= 0) ? x : y;
      if (z < 0) unreachable(); // useless test
    }

    int k;
    while ((k = getInt()) >= 0) {
      if (k < 0) unreachable(); // useless test
    }

    if (x > 0) {
      int z = x & y;
      if (!(z <= x)) unreachable(); // useless test
    }

    if (x % 2 == 0) {
      for (int i = 0; i < x; i+=2) {
        if (i + 1 >= x) unreachable(); // useless test
      }
    }

    int r = new Random().nextInt(x);
    if (r >= x) unreachable(); // useless test

    if (x > Math.max(x, y)) unreachable(); // useless test
    if (x < Math.min(x, y)) unreachable(); // useless test

    int w;
    if (x > 7) {
      w = x + 10;
    } else if (y > 20) {
      w = y - 10;
    } else {
      w = 14;
    }
    w--;
    w -= 2;
    if (w <= 5) unreachable(); // useless test

    while ((w--) > 0) {
      if (w < 0) unreachable(); // useless test
    }
    if (w != -1) unreachable(); // useless test

    if (x > 20) {
      int i;
      for (i = x; i > 0; i--) { }
      if (i != 0) unreachable(); // useless test
    }

    if (getInt() > 0) {
      int z = y;
      if (getInt() > 5) {
        z++;
        if (z >= 3) return;
      } else {
        if (z >= 4) return;
      }
      if (z >= 4) unreachable(); // useless test
    }

    int length = getInt();
    while (length > 0) {
      int cnt = getInt();
      length -= cnt;
    }
    for (int i = 0; i < length; ++i) { } // useless test

    int b = getInt();
    if (b > 4) b = 8;
    if (b > 8) unreachable(); // useless test

    int sz = getInt();
    if (0 < x && x < sz) {
      while (sz < x) { // useless test - false negative
        sz <<= 1;
      }
    }
  }

  void overflowTests(int x, int y) {
    if (x > 0) {
      if (y + x <= y) overflow();
      int d = x;
      if ((d += y) <= y) overflow();
    }

    if (x >= 0 && y >= 0) {
      if (x + y < 0) overflow();
    }

    int ofs = 1;
    while (ofs < x) {
      ofs = (ofs << 1) + 1;
      if (ofs <= 0) { ofs = x; overflow(); }
    }

    int sz = getInt();
    if (0 < x && 0 < sz) {
      while (sz < x) {
        sz <<= 1;
        if (sz <= 0) overflow();
      }
    }
  }

  void overflowTests2(int[] a, boolean b) {
    int newlen = b ? (a.length + 1) << 1 : (a.length >> 1) + a.length;
    if (newlen < 0) overflow();
  }

  static final long VAL = 100L;

  long overflowAwareIncrease(long x) {
    if (x + VAL > x) {
      return x + VAL;
    } else {
      overflow();
      return Long.MAX_VALUE;
    }
  }

  long overflowAwareDecrease(long x) {
    if (x - VAL < x) {
      return x - VAL;
    } else {
      overflow();
      return Long.MIN_VALUE;
    }
  }

  void overflow() { }

  void unreachableCode() {
    if (true) return;
    for (int i = 0; i < 10; i++) { }
  }
}
