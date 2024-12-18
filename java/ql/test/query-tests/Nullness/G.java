public class G {

  public static void test(String s) {

    if (s == null) {
      System.out.println("Is null");
    }

    switch(s) { // OK; null case means this doesn't throw.
      case null -> System.out.println("Null");
      case "foo" -> System.out.println("Foo");
      default -> System.out.println("Something else");
    }

    var x = switch(s) { // OK; null case (combined with default) means this doesn't throw.
      case "foo" -> "foo";
      case null, default -> "bar";
    };

    switch(s) { // BAD; lack of a null case means this may throw.
      case "foo" -> System.out.println("Foo");
      case String s2 -> System.out.println("Other string of length " + s2.length());
    }

  }

}
