import org.apache.commons.text.StringTokenizer;
import org.apache.commons.text.matcher.StringMatcher;

public class StringTokenizerTest {
  String taint() { return "tainted"; }

  void sink(Object o) {}

  void test() throws Exception {

    // Test constructors:
    sink((new StringTokenizer(taint().toCharArray())).toString()); // $hasTaintFlow=y
    sink((new StringTokenizer(taint().toCharArray(), ',')).toString()); // $hasTaintFlow=y
    sink((new StringTokenizer(taint().toCharArray(), ',', '"')).toString()); // $hasTaintFlow=y
    sink((new StringTokenizer(taint().toCharArray(), ",")).toString()); // $hasTaintFlow=y
    sink((new StringTokenizer(taint().toCharArray(), (StringMatcher)null)).toString()); // $hasTaintFlow=y
    sink((new StringTokenizer(taint().toCharArray(), (StringMatcher)null, (StringMatcher)null)).toString()); // $hasTaintFlow=y
    sink((new StringTokenizer(taint())).toString()); // $hasTaintFlow=y
    sink((new StringTokenizer(taint(), ',')).toString()); // $hasTaintFlow=y
    sink((new StringTokenizer(taint(), ',', '"')).toString()); // $hasTaintFlow=y
    sink((new StringTokenizer(taint(), ",")).toString()); // $hasTaintFlow=y
    sink((new StringTokenizer(taint(), (StringMatcher)null)).toString()); // $hasTaintFlow=y
    sink((new StringTokenizer(taint(), (StringMatcher)null, (StringMatcher)null)).toString()); // $hasTaintFlow=y

    // Test constructing static methods:
    sink(StringTokenizer.getCSVInstance(taint().toCharArray()).toString()); // $hasTaintFlow=y
    sink(StringTokenizer.getCSVInstance(taint()).toString()); // $hasTaintFlow=y
    sink(StringTokenizer.getTSVInstance(taint().toCharArray()).toString()); // $hasTaintFlow=y
    sink(StringTokenizer.getTSVInstance(taint()).toString()); // $hasTaintFlow=y

    // Test accessors:
    sink((new StringTokenizer(taint())).clone()); // $hasTaintFlow=y
    sink((new StringTokenizer(taint())).getContent()); // $hasTaintFlow=y
    sink((new StringTokenizer(taint())).getTokenArray()); // $hasTaintFlow=y
    sink((new StringTokenizer(taint())).getTokenList()); // $hasTaintFlow=y
    sink((new StringTokenizer(taint())).next()); // $hasTaintFlow=y
    sink((new StringTokenizer(taint())).nextToken()); // $hasTaintFlow=y
    sink((new StringTokenizer(taint())).previous()); // $hasTaintFlow=y
    sink((new StringTokenizer(taint())).previousToken()); // $hasTaintFlow=y

    // Test mutators:
    sink((new StringTokenizer()).reset(taint().toCharArray()).toString()); // $hasTaintFlow=y
    sink((new StringTokenizer()).reset(taint()).toString()); // $hasTaintFlow=y

  }
}