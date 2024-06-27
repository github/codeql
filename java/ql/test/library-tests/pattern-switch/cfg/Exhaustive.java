public class Exhaustive {

  enum E { A, B, C };
  sealed interface I permits X, Y { }
  final class X implements I { }
  final class Y implements I { }

  public static void test(E e, I i, Object o) {

    // Check the CFGs of three different ways to be exhaustive -- in particular there shouldn't be a fall-through nothing-matched edge.
    switch (o) {
      case String s -> { }
      case Object o2 -> { }
    }

    // Exhaustiveness not yet detected by CodeQL, because it is legal to omit some enum entries without a `default` case,
    // so we'd need to check every enum entry in the type of E occurs in some case.
    switch (e) {
      case A -> { }
      case B -> { }
      case C -> { }
    }

    switch (i) {
      case X x -> { }
      case Y y -> { }
    }

    // Test the case where a pattern case falls directly out of a block:
    switch (i) {
      case X _:
      case Y _:
    }

  }

}
