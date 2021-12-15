import org.apache.commons.text.StringTokenizer;
import org.apache.commons.text.matcher.StringMatcher;

public class StringTokenizerTest {
  String taint() { return "tainted"; }

  void sink(Object o) {}

  void test() throws Exception {

    // Test constructors:
    sink((new StringTokenizer(taint().toCharArray())).toString()); // $hasTaintFlow
    sink((new StringTokenizer(taint().toCharArray(), ',')).toString()); // $hasTaintFlow
    sink((new StringTokenizer(taint().toCharArray(), ',', '"')).toString()); // $hasTaintFlow
    sink((new StringTokenizer(taint().toCharArray(), ",")).toString()); // $hasTaintFlow
    sink((new StringTokenizer(taint().toCharArray(), (StringMatcher)null)).toString()); // $hasTaintFlow
    sink((new StringTokenizer(taint().toCharArray(), (StringMatcher)null, (StringMatcher)null)).toString()); // $hasTaintFlow
    sink((new StringTokenizer(taint())).toString()); // $hasTaintFlow
    sink((new StringTokenizer(taint(), ',')).toString()); // $hasTaintFlow
    sink((new StringTokenizer(taint(), ',', '"')).toString()); // $hasTaintFlow
    sink((new StringTokenizer(taint(), ",")).toString()); // $hasTaintFlow
    sink((new StringTokenizer(taint(), (StringMatcher)null)).toString()); // $hasTaintFlow
    sink((new StringTokenizer(taint(), (StringMatcher)null, (StringMatcher)null)).toString()); // $hasTaintFlow

    // Test constructing static methods:
    sink(StringTokenizer.getCSVInstance(taint().toCharArray()).toString()); // $hasTaintFlow
    sink(StringTokenizer.getCSVInstance(taint()).toString()); // $hasTaintFlow
    sink(StringTokenizer.getTSVInstance(taint().toCharArray()).toString()); // $hasTaintFlow
    sink(StringTokenizer.getTSVInstance(taint()).toString()); // $hasTaintFlow

    // Test accessors:
    sink((new StringTokenizer(taint())).clone()); // $hasTaintFlow
    sink((new StringTokenizer(taint())).getContent()); // $hasTaintFlow
    sink((new StringTokenizer(taint())).getTokenArray()); // $hasTaintFlow
    sink((new StringTokenizer(taint())).getTokenList()); // $hasTaintFlow
    sink((new StringTokenizer(taint())).next()); // $hasTaintFlow
    sink((new StringTokenizer(taint())).nextToken()); // $hasTaintFlow
    sink((new StringTokenizer(taint())).previous()); // $hasTaintFlow
    sink((new StringTokenizer(taint())).previousToken()); // $hasTaintFlow

    // Test mutators:
    sink((new StringTokenizer()).reset(taint().toCharArray()).toString()); // $hasTaintFlow
    sink((new StringTokenizer()).reset(taint()).toString()); // $hasTaintFlow

  }
}
