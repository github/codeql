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

    switch(s) { // BAD; lack of a null case means this may throw.
      case "foo" -> System.out.println("Foo");
      default -> System.out.println("Something else");
    }

  }

}
