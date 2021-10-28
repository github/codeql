import java.util.*;

public class Test {
  static String tainted;

  void sink(Object o) { }

  public void run() {
    HashMap<String, String> m = new HashMap<>();
    String x1 = m.get("key");
    sink(x1); // No flow

    m.put("key", tainted);
    String x2 = m.get("key");
    sink(x2); // Flow

    String x3 = m.values().toArray(new String[1])[0];
    sink(x3); // Flow

    for(Map.Entry<String, String> e : m.entrySet()) {
      String x4 = e.getValue();
      sink(x4); // Flow
    }

    Iterator<String> it = m.values().iterator();
    String x5 = it.next();
    sink(x5); // Flow

    it.forEachRemaining(x6 -> {
      sink(x6); // Flow
    });

    m.forEach((x7_k, x8_v) -> {
      sink(x7_k); // No flow
      sink(x8_v); // Flow
    });

    m.entrySet().forEach(entry -> {
      String x9 = entry.getKey();
      String x10 = entry.getValue();
      sink(x9); // No flow
      sink(x10); // Flow
    });    
  }

  public void run2() {
    HashMap<String, String> m = new HashMap<>();

    m.put(tainted, tainted);
    
    m.forEach((x11_k, x12_v) -> {
      sink(x11_k); // Flow
      sink(x12_v); // Flow
    });

    m.entrySet().forEach(entry -> {
      String x13 = entry.getKey();
      String x14 = entry.getValue();
      sink(x13); // Flow
      sink(x14); // Flow
    });
  }

  public void run3() {
    Set<String> s = new HashSet<>();
    String x15 = s.iterator().next();
    sink(x15); // No flow

    s.forEach(x16 -> {
      sink(x16); // No flow
    });

    s.add(tainted);
    String x17 = s.iterator().next();
    sink(x17); // Flow

    s.forEach(x18 -> {
      sink(x18); // Flow
    });
  }
}
