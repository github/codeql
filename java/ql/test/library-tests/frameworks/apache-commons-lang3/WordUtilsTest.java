import org.apache.commons.lang3.text.WordUtils;

public class WordUtilsTest {
  String taint() { return "tainted"; }

  void sink(Object o) {}

  void test() throws Exception {
    sink(WordUtils.capitalize(taint())); // $hasTaintFlow
    sink(WordUtils.capitalize(taint(), ' ', ',')); // $hasTaintFlow
    sink(WordUtils.capitalizeFully(taint())); // $hasTaintFlow
    sink(WordUtils.capitalizeFully(taint(), ' ', ',')); // $hasTaintFlow
    sink(WordUtils.initials(taint())); // $hasTaintFlow
    sink(WordUtils.initials(taint(), ' ', ',')); // $hasTaintFlow
    sink(WordUtils.swapCase(taint())); // $hasTaintFlow
    sink(WordUtils.uncapitalize(taint())); // $hasTaintFlow
    sink(WordUtils.uncapitalize(taint(), ' ', ',')); // $hasTaintFlow
    sink(WordUtils.wrap(taint(), 0)); // $hasTaintFlow
    sink(WordUtils.wrap(taint(), 0, "\n", false)); // $hasTaintFlow
    sink(WordUtils.wrap("wrap me", 0, taint(), false)); // $hasTaintFlow
    sink(WordUtils.wrap(taint(), 0, "\n", false, "\n")); // $hasTaintFlow
    sink(WordUtils.wrap("wrap me", 0, taint(), false, "\n")); // $hasTaintFlow
    // GOOD: the wrap-on line terminator does not propagate to the return value
    sink(WordUtils.wrap("wrap me", 0, "\n", false, taint()));
  }
}
