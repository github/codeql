package test;

import java.util.List;

public class UnnamedVariables
{
  sealed interface Shape permits Circle, Square {}
  record Circle(double radius) implements Shape {}
  record Square(double side) implements Shape {}
  record Pair(Object left, Object right) {}

  // Not flagged: unnamed variables cannot be read
  static int side(Shape shape)
  {
    return switch (shape) {
      case Circle _ -> 0;
      case Square s -> (int) s.side();
    };
  }

  static Object left(Object o)
  {
    if (o instanceof Pair(var left, _)) {
      return left;
    }
    return switch (o) {
      case Pair(Object left, Object _) -> left;
      default -> null;
    };
  }

  static int count(List<String> items)
  {
    int n = 0;
    for (String _ : items) {
      n++;
    }
    return n;
  }

  static void removeFirst(List<String> items)
  {
    var _ = items.remove(0);
  }
}
