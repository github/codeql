import java.util.*;
import java.util.stream.*;

public class A {
  String source() { return "source"; }

  void sink(Object o) { }

  void m() {
    String[] xs = new String[] { source() };
    Stream<String> s = Arrays.stream(xs);

    sink(s.collect(Collectors.maxBy(null)).get()); // $ hasValueFlow
    sink(s.collect(Collectors.minBy(null)).get()); // $ hasValueFlow
    sink(s.collect(Collectors.toCollection(null)).iterator().next()); // $ hasValueFlow
    sink(s.collect(Collectors.toList()).get(0)); // $ hasValueFlow
    sink(s.collect(Collectors.toSet()).iterator().next()); // $ hasValueFlow
    sink(s.collect(Collectors.toUnmodifiableList()).get(0)); // $ hasValueFlow
    sink(s.collect(Collectors.toUnmodifiableSet()).iterator().next()); // $ hasValueFlow

    // we don't attempt to cover weird things like this:
    sink(s.collect(true ? Collectors.toList() : null).get(0)); // $ MISSING: hasValueFlow

    sink(s.collect(Collectors.joining())); // $ hasTaintFlow

    sink(s.collect(Collectors.groupingBy(null)).get(null).get(0)); // $ hasValueFlow
    sink(s.collect(Collectors.groupingByConcurrent(null)).get(null).get(0)); // $ hasValueFlow
    sink(s.collect(Collectors.partitioningBy(null)).get(null).get(0)); // $ hasValueFlow
  }
}
