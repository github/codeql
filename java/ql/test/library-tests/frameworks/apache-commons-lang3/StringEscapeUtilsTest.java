import org.apache.commons.lang3.StringEscapeUtils;

public class StringEscapeUtilsTest {
  String taint() { return "tainted"; }

  void sink(Object o) {}

  void test() throws Exception {
    sink(StringEscapeUtils.escapeJson(taint())); // $hasTaintFlow
  }
}
