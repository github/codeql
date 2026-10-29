public class Test {

  interface Intf { }
  static class Specific implements Intf { public String toString() { return "Specific"; } }
  static class Alternative implements Intf { public String toString() { return "Alternative"; } }

  public static String caller() {

    Alternative a = new Alternative(); // Instantiate this somewhere so there are at least two candidate types in general
    return test(new Specific());

  }

  public static String test(Object o) {

    if (o instanceof Object o2) {
      // So we should know o2.toString is really Specific.toString():
      return o2.toString();
    }

    switch (o) {
      case Object o2 when o2.hashCode() > 0 -> { return o2.toString(); } // Same goes for this `o2`
      default -> { return "Not an Intf"; }
    }

  }

}

