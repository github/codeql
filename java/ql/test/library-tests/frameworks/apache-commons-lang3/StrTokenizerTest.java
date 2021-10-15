import org.apache.commons.lang3.text.StrTokenizer;
import org.apache.commons.lang3.text.StrMatcher;

public class StrTokenizerTest {
  String taint() { return "tainted"; }

  void sink(Object o) {}

  void test() throws Exception {

    // Test constructors:
    sink((new StrTokenizer(taint().toCharArray())).toString()); // $hasTaintFlow
    sink((new StrTokenizer(taint().toCharArray(), ',')).toString()); // $hasTaintFlow
    sink((new StrTokenizer(taint().toCharArray(), ',', '"')).toString()); // $hasTaintFlow
    sink((new StrTokenizer(taint().toCharArray(), ",")).toString()); // $hasTaintFlow
    sink((new StrTokenizer(taint().toCharArray(), (StrMatcher)null)).toString()); // $hasTaintFlow
    sink((new StrTokenizer(taint().toCharArray(), (StrMatcher)null, (StrMatcher)null)).toString()); // $hasTaintFlow
    sink((new StrTokenizer(taint())).toString()); // $hasTaintFlow
    sink((new StrTokenizer(taint(), ',')).toString()); // $hasTaintFlow
    sink((new StrTokenizer(taint(), ',', '"')).toString()); // $hasTaintFlow
    sink((new StrTokenizer(taint(), ",")).toString()); // $hasTaintFlow
    sink((new StrTokenizer(taint(), (StrMatcher)null)).toString()); // $hasTaintFlow
    sink((new StrTokenizer(taint(), (StrMatcher)null, (StrMatcher)null)).toString()); // $hasTaintFlow

    // Test constructing static methods:
    sink(StrTokenizer.getCSVInstance(taint().toCharArray()).toString()); // $hasTaintFlow
    sink(StrTokenizer.getCSVInstance(taint()).toString()); // $hasTaintFlow
    sink(StrTokenizer.getTSVInstance(taint().toCharArray()).toString()); // $hasTaintFlow
    sink(StrTokenizer.getTSVInstance(taint()).toString()); // $hasTaintFlow

    // Test accessors:
    sink((new StrTokenizer(taint())).clone()); // $hasTaintFlow
    sink((new StrTokenizer(taint())).getContent()); // $hasTaintFlow
    sink((new StrTokenizer(taint())).getTokenArray()); // $hasTaintFlow
    sink((new StrTokenizer(taint())).getTokenList()); // $hasTaintFlow
    sink((new StrTokenizer(taint())).next()); // $hasTaintFlow
    sink((new StrTokenizer(taint())).nextToken()); // $hasTaintFlow
    sink((new StrTokenizer(taint())).previous()); // $hasTaintFlow
    sink((new StrTokenizer(taint())).previousToken()); // $hasTaintFlow

    // Test mutators:
    sink((new StrTokenizer()).reset(taint().toCharArray()).toString()); // $hasTaintFlow
    sink((new StrTokenizer()).reset(taint()).toString()); // $hasTaintFlow

  }
}
