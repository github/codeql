import org.apache.commons.text.lookup.StringLookup;
import org.apache.commons.text.lookup.StringLookupFactory;
import java.util.HashMap;
import java.util.Map;

class StringLookupTextTest {
    String taint() { return "tainted"; }

    void sink(Object o) {}

    void test() throws Exception {
      Map<String, String> map = new HashMap<String, String>();
      map.put("key", taint());
      StringLookup lookup = StringLookupFactory.INSTANCE.mapStringLookup(map);
      sink(lookup.lookup("key")); // $hasTaintFlow
    }

}
