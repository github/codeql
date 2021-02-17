import org.apache.commons.text.StrTokenizer;
import org.apache.commons.text.StrMatcher;

public class StrTokenizerTextTest {
  String taint() { return "tainted"; }

  void sink(Object o) {}

  void test() throws Exception {

    // Test constructors:
    sink((new StrTokenizer(taint().toCharArray())).toString()); // $hasTaintFlow=y
    sink((new StrTokenizer(taint().toCharArray(), ',')).toString()); // $hasTaintFlow=y
    sink((new StrTokenizer(taint().toCharArray(), ',', '"')).toString()); // $hasTaintFlow=y
    sink((new StrTokenizer(taint().toCharArray(), ",")).toString()); // $hasTaintFlow=y
    sink((new StrTokenizer(taint().toCharArray(), (StrMatcher)null)).toString()); // $hasTaintFlow=y
    sink((new StrTokenizer(taint().toCharArray(), (StrMatcher)null, (StrMatcher)null)).toString()); // $hasTaintFlow=y
    sink((new StrTokenizer(taint())).toString()); // $hasTaintFlow=y
    sink((new StrTokenizer(taint(), ',')).toString()); // $hasTaintFlow=y
    sink((new StrTokenizer(taint(), ',', '"')).toString()); // $hasTaintFlow=y
    sink((new StrTokenizer(taint(), ",")).toString()); // $hasTaintFlow=y
    sink((new StrTokenizer(taint(), (StrMatcher)null)).toString()); // $hasTaintFlow=y
    sink((new StrTokenizer(taint(), (StrMatcher)null, (StrMatcher)null)).toString()); // $hasTaintFlow=y

    // Test constructing static methods:
    sink(StrTokenizer.getCSVInstance(taint().toCharArray()).toString()); // $hasTaintFlow=y
    sink(StrTokenizer.getCSVInstance(taint()).toString()); // $hasTaintFlow=y
    sink(StrTokenizer.getTSVInstance(taint().toCharArray()).toString()); // $hasTaintFlow=y
    sink(StrTokenizer.getTSVInstance(taint()).toString()); // $hasTaintFlow=y

    // Test accessors:
    sink((new StrTokenizer(taint())).clone()); // $hasTaintFlow=y
    sink((new StrTokenizer(taint())).getContent()); // $hasTaintFlow=y
    sink((new StrTokenizer(taint())).getTokenArray()); // $hasTaintFlow=y
    sink((new StrTokenizer(taint())).getTokenList()); // $hasTaintFlow=y
    sink((new StrTokenizer(taint())).next()); // $hasTaintFlow=y
    sink((new StrTokenizer(taint())).nextToken()); // $hasTaintFlow=y
    sink((new StrTokenizer(taint())).previous()); // $hasTaintFlow=y
    sink((new StrTokenizer(taint())).previousToken()); // $hasTaintFlow=y

    // Test mutators:
    sink((new StrTokenizer()).reset(taint().toCharArray()).toString()); // $hasTaintFlow=y
    sink((new StrTokenizer()).reset(taint()).toString()); // $hasTaintFlow=y

  }
}