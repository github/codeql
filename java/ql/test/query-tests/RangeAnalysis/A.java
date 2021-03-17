import java.util.Random;
import org.apache.commons.lang3.RandomUtils;

public class A {
  private static final int[] arr1 = new int[] { 1, 2, 3, 4, 5, 6, 7, 8 };
  private final int[] arr2;
  private final int[] arr3;

  public A(int[] arr2, int n) {
    if (arr2.length % 2 != 0)
      throw new Error();
    this.arr2 = arr2;
    this.arr3 = new int[n << 1];
  }

  void m1(int[] a) {
    int sum = 0;
    for (int i = 0; i <= a.length; i++) {
      sum += a[i]; // Out of bounds
    }
  }

  void m2(int[] a) {
    int sum = 0;
    for (int i = 0; i < a.length; i += 2) {
      sum += a[i] + a[i + 1]; // Out of bounds (unless len%2==0)
    }
  }

  void m3(int[] a) {
    if (a.length % 2 != 0)
      return;
    int sum = 0;
    for (int i = 0; i < a.length; ) {
      sum += a[i++]; // OK
      sum += a[i++]; // OK
    }
    for (int i = 0; i < arr1.length; ) {
      sum += arr1[i++]; // OK
      sum += arr1[i++]; // OK
      i += 2;
    }
    for (int i = 0; i < arr2.length; ) {
      sum += arr2[i++]; // OK
      sum += arr2[i++]; // OK - FP
    }
    for (int i = 0; i < arr3.length; ) {
      sum += arr3[i++]; // OK
      sum += arr3[i++]; // OK - FP
    }
    int[] b;
    if (sum > 3)
      b = a;
    else
      b = arr1;
    for (int i = 0; i < b.length; i++) {
      sum += b[i]; // OK
      sum += b[++i]; // OK - FP
    }
  }

  void m4(int[] a, int[] b) {
    assert a.length % 2 == 0;
    int sum = 0;
    for (int i = 0; i < a.length; ) {
      sum += a[i++]; // OK
      sum += a[i++]; // OK - FP
    }
    int len = b.length;
    if ((len & 1) != 0)
      return;
    for (int i = 0; i < len; ) {
      sum += b[i++]; // OK
      sum += b[i++]; // OK
    }
  }

  void m5(int n) {
    int[] a = new int[3 * n];
    int sum = 0;
    for (int i = 0; i < a.length; i += 3) {
      sum += a[i] + a[i + 1] + a[i + 2]; // OK
    }
  }

  int m6(int[] a, int ix) {
    if (ix < 0 || ix > a.length)
      return 0;
    return a[ix]; // Out of bounds
  }

  void m7() {
    int[] xs = new int[11];
    int sum = 0;
    for (int i = 0; i < 11; i++) {
      for (int j = 0; j < 11; j++) {
        sum += xs[i]; // OK
        sum += xs[j]; // OK
        if (i < j)
          sum += xs[i + 11 - j]; // OK - FP
        else
          sum += xs[i - j]; // OK
      }
    }
  }

  void m8(int[] a) {
    if ((a.length - 4) % 3 != 0)
      return;
    int sum = 0;
    for (int i = 4; i < a.length; i += 3) {
      sum += a[i]; // OK
      sum += a[i + 1]; // OK - FP
      sum += a[i + 2]; // OK - FP
    }
  }

  void m9() {
    int[] a = new int[] { 1, 2, 3, 4, 5 };
    int sum = 0;
    for (int i = 0; i < 10; i++) {
      if (i < 5)
        sum += a[i]; // OK
      else
        sum += a[9 - i]; // OK - FP
    }
  }

  void m10(int n, int m) {
    int len = Math.min(n, m);
    int[] a = new int[n];
    int sum = 0;
    for (int i = n - 1; i >= 0; i--) {
      sum += a[i]; // OK
      for (int j = i + 1; j < len; j++) {
        sum += a[j]; // OK
        sum += a[i + 1]; // OK - FP
      }
    }
  }

  void m11(int n) {
    int len = n*2;
    int[] a = new int[len];
    int sum = 0;
    for (int i = 0; i < len; i = i + 2) {
      sum += a[i+1]; // OK
      for (int j = i; j < len - 2; j = j + 2) {
        sum += a[j]; // OK
        sum += a[j+1]; // OK
        sum += a[j+2]; // OK
        sum += a[j+3]; // OK
      }
    }
  }

  void m12() {
    int[] a = new int[] { 1, 2, 3, 4, 5, 6 };
    int sum = 0;
    for (int i = 0; i < a.length; i += 2) {
      sum += a[i] + a[i + 1]; // OK
    }
    int[] b = new int[8];
    for (int i = 2; i < 8; i += 2) {
      sum += b[i] + b[i + 1]; // OK
    }
  }

  void m13(int n) {
    int[] a = null;
    if (n > 0) {
      a = n > 0 ? new int[3 * n] : null;
    }
    int sum = 0;
    if (a != null) {
      for (int i = 0; i < a.length; i += 3) {
        sum += a[i + 2]; // OK
      }
    }
  }

  void m14(int[] xs) {
    for (int i = 0; i < xs.length + 1; i++) {
      if (i == 0 && xs.length > 0) {
        xs[i]++; // OK - FP
      }
    }
  }

  void m15(int[] xs) {
    for (int i = 0; i < xs.length; i++) {
      int x = ++i;
      int y = ++i;
      if (y < xs.length) {
        xs[x]++; // OK - FP
        xs[y]++; // OK
      }
    }
  }

  static int m16() {
    return A.arr1[(new Random()).nextInt(arr1.length + 1)] +  // BAD: random int may be out of range
      A.arr1[(new Random()).nextInt(arr1.length)] + // GOOD: random int must be in range
      A.arr1[RandomUtils.nextInt(0, arr1.length + 1)] + // BAD: random int may be out of range
      A.arr1[RandomUtils.nextInt(0, arr1.length)]; // GOOD: random int must be in range
  }
}
