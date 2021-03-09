import org.apache.commons.lang3.text.StrLookup;
import java.util.HashMap;
import java.util.Map;

class StrLookupTest {
    String taint() { return "tainted"; }

    void sink(Object o) {}

    void test() throws Exception {
      Map<String, String> map = new HashMap<String, String>();
      map.put("key", taint());
      StrLookup<String> lookup = StrLookup.mapLookup(map);
      sink(lookup.lookup("key")); // $hasTaintFlow
    }

}
