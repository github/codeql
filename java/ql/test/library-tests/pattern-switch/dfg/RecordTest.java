public class RecordTest {

  interface I { }
  record Middle(String field) { }
  record A(Middle afield) implements I { }
  record B(Middle bfield) implements I { }

  public static String sink(String s) { return s; }

  public static void test(boolean inp) {

    I i = inp ? new A(new Middle("A")) : new B(new Middle("B"));

    switch(i) {
      case A(Middle(String field)):
        sink(field);
        break;
      case B(Middle(String field)):
        sink(field);
        break;
      default:
        break;
    }

    switch(i) {
      case A(Middle(String field)) -> sink(field);
      case B(Middle(String field)) -> sink(field);
      default -> { }
    }

    var x = switch(i) {
      case A(Middle(String field)):
        yield sink(field);
      case B(Middle(String field)):
        yield sink(field);
      default:
        yield "Default case";
    };

    var y = switch(i) {
      case A(Middle(String field)) -> sink(field);
      case B(Middle(String field)) -> sink(field);
      default -> "Default case";
    };

  }

}
