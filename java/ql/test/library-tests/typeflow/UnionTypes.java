import java.util.*;
import java.util.concurrent.*;

public class UnionTypes {
  public void m1() {
    m1_map_put(new LinkedHashMap<>(), "k", "v");
    m1_map_put(new ConcurrentHashMap<>(), "k", "v");
  }

  private void m1_map_put(Map<String, String> m, String k, String v) {
    m.put(k, v);
  }

  static class Sup { }
  interface Inter { }

  static class A1 extends Sup implements Inter { }
  static class A2 extends Sup implements Inter { }
  static class A3 extends Sup { }
  static class A4 extends Sup implements Inter { }
  static class A2sub extends A2 { }

  private void m2(boolean b) {
    scc1(new A1(), 10);
    Sup x = b ? new A2() : new A3();
    scc2(x, 10);
  }

  private void scc1(Sup x1, int i) {
    scc2(x1, i);
  }

  private void scc2(Sup x2, int i) {
    scc3(x2, i);
  }

  private void scc3(Sup x3, int i) {
    next(x3);
    if (i > 0)
      scc1(x3, --i);
  }

  private void next(Sup x) {
    if (x instanceof Inter) {
      x.hashCode();
    }
    var hashCode = switch (x) {
      case Inter i -> x.hashCode();
      default -> 0;
    };
  }

  void m3(Object d) {
    if (d instanceof A1 || d instanceof A2 || d instanceof A3) {
      d.hashCode();
    }
  }
}
