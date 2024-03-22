import java.io.Closeable;
import java.util.List;
import java.util.function.BiFunction;

record SubRecord(int z) { }
record MyRecord(int x, SubRecord y) { }

public class AnonDecls {

  public static void test(List<String> ss, Object o) {

    // Note each construct is repeated to ensure this doesn't produce database inconsistencies

    int _ = 1;
    int _ = 2;

    try (Closeable _ = null) { } catch (Exception _) { }
    try (Closeable _ = null) { } catch (Exception _) { }

    int x = 0;

    for (int _ = 1; x < 10; x++) { }
    for (int _ = 2; x > 0; x--) { }

    for (var _ : ss) { }
    for (var _ : ss) { }

    BiFunction<Integer, Integer, Integer> f1 = (_, _) -> 1;
    BiFunction<Integer, Integer, Integer> f2 = (_, _) -> 2;

    switch (o) {
      case SubRecord _:
      case MyRecord _:
      default:
    }

    switch (o) {
      case SubRecord _:
      case MyRecord (int _, SubRecord _):
      default:
    }

    switch (o) {
      case SubRecord _:
      case MyRecord (int _, SubRecord (int _)):
      default:
    }

    switch (o) {
      case SubRecord _:
      case MyRecord (_, _):
      default:
    }

    switch (o) {
      case MyRecord (_, _), SubRecord(_):
      default:
    }

    switch (o) {
      case MyRecord (_, _), SubRecord(_) when ss != null:
      default:
    }

    switch (o) {
      // Note use of binding patterns, not records with unnamed patterns as above
      case MyRecord _, SubRecord _:
      default:
    }

    switch (o) {
      case SubRecord _ -> { }
      case MyRecord _ -> { }
      default -> { }
    }

    switch (o) {
      case SubRecord _ -> { }
      case MyRecord (int _, SubRecord _) -> { }
      default -> { }
    }

    switch (o) {
      case SubRecord _ -> { }
      case MyRecord (int _, SubRecord (int _)) -> { }
      default -> { }
    }

    switch (o) {
      case SubRecord _ -> { }
      case MyRecord (_, _) -> { }
      default -> { }
    }

    switch (o) {
      case MyRecord (_, _), SubRecord(_) -> { }
      default -> { }
    }

    switch (o) {
      case MyRecord (_, _), SubRecord(_) when ss != null -> { }
      default -> { }
    }

    var x1 = switch (o) {
      case SubRecord _:
      case MyRecord _:
      default:
        yield 1;
    };

    var x2 = switch (o) {
      case SubRecord _:
      case MyRecord (int _, SubRecord _):
      default:
        yield 1;
    };

    var x3 = switch (o) {
      case SubRecord _:
      case MyRecord (int _, SubRecord (int _)):
      default:
        yield 1;
    };

    var x4 = switch (o) {
      case SubRecord _:
      case MyRecord (_, _):
      default:
        yield 1;
    };

    var x5 = switch (o) {
      case MyRecord (_, _), SubRecord(_):
      default:
        yield 1;
    };

    var x6 = switch (o) {
      case MyRecord (_, _), SubRecord(_) when ss != null:
      default:
        yield 1;
    };  

    var x7 = switch (o) {
      case SubRecord _ -> 1;
      case MyRecord _ -> 2;
      default -> 3;
    };

    var x8 = switch (o) {
      case SubRecord _ -> 1;
      case MyRecord (int _, SubRecord _) -> 2;
      default -> 3;
    };

    var x9 = switch (o) {
      case SubRecord _ -> 1;
      case MyRecord (int _, SubRecord (int _)) -> 2;
      default -> 3;
    };

    var x10 = switch (o) {
      case SubRecord _ -> 1;
      case MyRecord (_, _) -> 2;
      default -> 3;
    };

    var x11 = switch (o) {
      case MyRecord (_, _), SubRecord(_) -> 1;
      default -> 2;
    };

    var x12 = switch (o) {
      case MyRecord (_, _), SubRecord(_) when ss != null -> 1;
      default -> 2;
    };  

  }

}
