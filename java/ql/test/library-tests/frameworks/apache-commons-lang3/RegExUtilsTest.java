import org.apache.commons.lang3.RegExUtils;
import java.util.regex.Pattern;

public class RegExUtilsTest {
  String taint() { return "tainted"; }

  void sink(Object o) {}

  void test() throws Exception {
    Pattern cleanPattern = Pattern.compile("clean");
    Pattern taintedPattern = Pattern.compile(taint());

    sink(RegExUtils.removeAll(taint(), cleanPattern)); // $hasTaintFlow
    sink(RegExUtils.removeAll(taint(), "clean")); // $hasTaintFlow
    sink(RegExUtils.removeFirst(taint(), cleanPattern)); // $hasTaintFlow
    sink(RegExUtils.removeFirst(taint(), "clean")); // $hasTaintFlow
    sink(RegExUtils.removePattern(taint(), "clean")); // $hasTaintFlow
    sink(RegExUtils.replaceAll(taint(), cleanPattern, "replacement")); // $hasTaintFlow
    sink(RegExUtils.replaceAll(taint(), "clean", "replacement")); // $hasTaintFlow
    sink(RegExUtils.replaceFirst(taint(), cleanPattern, "replacement")); // $hasTaintFlow
    sink(RegExUtils.replaceFirst(taint(), "clean", "replacement")); // $hasTaintFlow
    sink(RegExUtils.replacePattern(taint(), "clean", "replacement")); // $hasTaintFlow
    sink(RegExUtils.replaceAll("original", cleanPattern, taint())); // $hasTaintFlow
    sink(RegExUtils.replaceAll("original", "clean", taint())); // $hasTaintFlow
    sink(RegExUtils.replaceFirst("original", cleanPattern, taint())); // $hasTaintFlow
    sink(RegExUtils.replaceFirst("original", "clean", taint())); // $hasTaintFlow
    sink(RegExUtils.replacePattern("original", "clean", taint())); // $hasTaintFlow
    // Subsequent calls don't propagate taint, as regex search patterns don't propagate to the return value.
    sink(RegExUtils.removeAll("original", taintedPattern));
    sink(RegExUtils.removeAll("original", taint()));
    sink(RegExUtils.removeFirst("original", taintedPattern));
    sink(RegExUtils.removeFirst("original", taint()));
    sink(RegExUtils.removePattern("original", taint()));
    sink(RegExUtils.replaceAll("original", taintedPattern, "replacement"));
    sink(RegExUtils.replaceAll("original", taint(), "replacement"));
    sink(RegExUtils.replaceFirst("original", taintedPattern, "replacement"));
    sink(RegExUtils.replaceFirst("original", taint(), "replacement"));
    sink(RegExUtils.replacePattern("original", taint(), "replacement"));
    sink(RegExUtils.replaceAll("original", taintedPattern, "replacement"));
    sink(RegExUtils.replaceAll("original", taint(), "replacement"));
    sink(RegExUtils.replaceFirst("original", taintedPattern, "replacement"));
    sink(RegExUtils.replaceFirst("original", taint(), "replacement"));
    sink(RegExUtils.replacePattern("original", taint(), "replacement"));
  }
}