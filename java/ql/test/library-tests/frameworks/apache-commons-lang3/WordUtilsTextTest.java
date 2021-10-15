import org.apache.commons.text.WordUtils;

public class WordUtilsTextTest {
  String taint() { return "tainted"; }

  void sink(Object o) {}

  void test() throws Exception {
    sink(WordUtils.abbreviate(taint(), 0, 0, "append me")); // $hasTaintFlow
    sink(WordUtils.abbreviate("abbreviate me", 0, 0, taint())); // $hasTaintFlow
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
