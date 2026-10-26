package dispatchtest.one;

import dispatchtest.two.*;
import java.util.*;

public class ViableCallableA {
  void packA() { }
  public void pub() { }

  private static ViableCallableB getB() { return new ViableCallableB(); }

  public static void f() {
    ViableCallableB b = new ViableCallableB();
    ((ViableCallableA)b).packA();

    ViableCallableA a = getB();
    a.packA();

    ArrayList<? extends ViableCallableA> l = new ArrayList<>();
    l.get(0).pub();
  }
}
