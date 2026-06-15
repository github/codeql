public class Test {

  private interface Intf { String get(); }
  private static class Specific implements Intf { public String get() { return "Specific"; } }
  private static class Alternative implements Intf { public String get() { return "Alternative"; } }

  public static String caller() {

    Alternative a = new Alternative(); // Instantiate this somewhere so there are at least two candidate types in general
    return test(new Specific());

  }

  public static String test(Object o) {

    if (o instanceof Intf i) {
      // So we should know i.get is really Specific.get():
      return i.get();
    }

    switch (o) {
      case Intf i -> { return i.get(); } // Same goes for this `i`
      default -> { return "Not an Intf"; }
    }

  }

}

