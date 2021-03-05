import org.apache.commons.lang3.text.WordUtils;

public class WordUtilsTest {
  String taint() { return "tainted"; }

  void sink(Object o) {}

  void test() throws Exception {
    sink(WordUtils.capitalize(taint())); // $hasTaintFlow=y
    sink(WordUtils.capitalize(taint(), ' ', ',')); // $hasTaintFlow=y
    sink(WordUtils.capitalizeFully(taint())); // $hasTaintFlow=y
    sink(WordUtils.capitalizeFully(taint(), ' ', ',')); // $hasTaintFlow=y
    sink(WordUtils.initials(taint())); // $hasTaintFlow=y
    sink(WordUtils.initials(taint(), ' ', ',')); // $hasTaintFlow=y
    sink(WordUtils.swapCase(taint())); // $hasTaintFlow=y
    sink(WordUtils.uncapitalize(taint())); // $hasTaintFlow=y
    sink(WordUtils.uncapitalize(taint(), ' ', ',')); // $hasTaintFlow=y
    sink(WordUtils.wrap(taint(), 0)); // $hasTaintFlow=y
    sink(WordUtils.wrap(taint(), 0, "\n", false)); // $hasTaintFlow=y
    sink(WordUtils.wrap("wrap me", 0, taint(), false)); // $hasTaintFlow=y
    sink(WordUtils.wrap(taint(), 0, "\n", false, "\n")); // $hasTaintFlow=y
    sink(WordUtils.wrap("wrap me", 0, taint(), false, "\n")); // $hasTaintFlow=y
    // GOOD: the wrap-on line terminator does not propagate to the return value
    sink(WordUtils.wrap("wrap me", 0, "\n", false, taint()));
  }
}