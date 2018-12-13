public class A {
  public class B {
    public int x = 2;
    public void setX(int x) {
      this.x = x;
    }
  }

  private String s;
  public String getString() {
    if (s == null) {
      synchronized(this) {
        if (s == null) {
          s = "string"; // OK, immutable
        }
      }
    }
    return s;
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
}
