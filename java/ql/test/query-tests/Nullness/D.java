import java.util.*;

public class D {
  public static List<Object> p;

  void init() {
    List<Object> l = new ArrayList<Object>();
    p = l;
  }

  void f() {
    int n = p == null ? 0 : p.size();
    for (int i = 0; i < n; i++) {
      Object o = p.get(i); // OK
    }
  }

  public static class MyList<T> extends ArrayList<T> {
    @Override
    public int size() {
      p = new ArrayList<Object>();
      return super.size();
    }
  }
}
