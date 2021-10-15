public class A {
  public class B {
    public int x = 2;
    public void setX(int x) {
      this.x = x;
    }
  }

  private String s1;
  public String getString1() {
    if (s1 == null) {
      synchronized(this) {
        if (s1 == null) {
          s1 = "string"; // BAD, immutable but read twice outside sync
        }
      }
    }
    return s1;
  }

  private String s2;
  public String getString2() {
    String x = s2;
    if (x == null) {
      synchronized(this) {
        x = s2;
        if (x == null) {
          x = "string"; // OK, immutable and read once outside sync
          s2 = x;
        }
      }
    }
    return x;
  }

  private B b1;
  public B getter1() {
    B x = b1;
    if (x == null) {
      synchronized(this) {
        if ((x = b1) == null) {
          b1 = new B(); // BAD, not volatile
          x = b1;
        }
      }
    }
    return x;
  }

  private volatile B b2;
  public B getter2() {
    B x = b2;
    if (x == null) {
      synchronized(this) {
        if ((x = b2) == null) {
          b2 = new B(); // OK
          x = b2;
          System.out.println("OK");
        }
      }
    }
    return x;
  }

  private volatile B b3;
  public B getter3() {
    if (b3 == null) {
      synchronized(this) {
        if (b3 == null) {
          b3 = new B();
          b3.x = 7; // BAD, post update init
        }
      }
    }
    return b3;
  }

  private volatile B b4;
  public B getter4() {
    if (b4 == null) {
      synchronized(this) {
        if (b4 == null) {
          b4 = new B();
          b4.setX(7); // BAD, post update init
        }
      }
    }
    return b4;
  }

  static class FinalHelper<T> {
    public final T x;
    public FinalHelper(T x) {
      this.x = x;
    }
  }

  private FinalHelper<B> b5;
  public B getter5() {
    if (b5 == null) {
      synchronized(this) {
        if (b5 == null) {
          B b = new B();
          b5 = new FinalHelper<B>(b); // BAD, racy read on b5 outside synchronized-block
        }
      }
    }
    return b5.x; // Potential NPE here, as the two b5 reads may be reordered
  }

  private FinalHelper<B> b6;
  public B getter6() {
    FinalHelper<B> a = b6;
    if (a == null) {
      synchronized(this) {
        a = b6;
        if (a == null) {
          B b = new B();
          a = new FinalHelper<B>(b);
          b6 = a; // OK, published through final field with a single non-synced read
        }
      }
    }
    return a.x;
  }
}
