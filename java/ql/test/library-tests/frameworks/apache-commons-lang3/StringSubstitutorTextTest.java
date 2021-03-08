import org.apache.commons.text.StringSubstitutor;
import org.apache.commons.text.lookup.StringLookup;
import org.apache.commons.text.lookup.StringLookupFactory;
import org.apache.commons.text.matcher.StringMatcher;
import org.apache.commons.text.TextStringBuilder;
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;

class StringSubstitutorTextTest {
    String taint() { return "tainted"; }

    void sink(Object o) {}

    void test() throws Exception {
      Map<String, String> taintedMap = new HashMap<String, String>();
      taintedMap.put("key", taint());
      StringLookup taintedLookup = StringLookupFactory.INSTANCE.mapStringLookup(taintedMap);

      // Test constructors:
      StringSubstitutor ss1 = new StringSubstitutor(); ss1.setVariableResolver(taintedLookup); sink(ss1.replace("input")); // $hasTaintFlow
      StringSubstitutor ss2 = new StringSubstitutor(taintedMap); sink(ss2.replace("input")); // $hasTaintFlow
      StringSubstitutor ss3 = new StringSubstitutor(taintedMap, "{", "}"); sink(ss3.replace("input")); // $hasTaintFlow
      StringSubstitutor ss4 = new StringSubstitutor(taintedMap, "{", "}", ' '); sink(ss4.replace("input")); // $hasTaintFlow
      StringSubstitutor ss5 = new StringSubstitutor(taintedMap, "{", "}", ' ', ","); sink(ss5.replace("input")); // $hasTaintFlow
      StringSubstitutor ss6 = new StringSubstitutor(taintedLookup); sink(ss6.replace("input")); // $hasTaintFlow
      StringSubstitutor ss7 = new StringSubstitutor(taintedLookup, "{", "}", ' '); sink(ss7.replace("input")); // $hasTaintFlow
      StringSubstitutor ss8 = new StringSubstitutor(taintedLookup, "{", "}", ' ', ","); sink(ss8.replace("input")); // $hasTaintFlow
      StringSubstitutor ss9 = new StringSubstitutor(taintedLookup, (StringMatcher)null, null, ' '); sink(ss9.replace("input")); // $hasTaintFlow
      StringSubstitutor ss10 = new StringSubstitutor(taintedLookup, (StringMatcher)null, null, ' ', null); sink(ss10.replace("input")); // $hasTaintFlow

      // Test replace overloads (tainted substitution map):
      StringSubstitutor taintedSubst = ss2;
      sink(taintedSubst.replace((Object)"input")); // $hasTaintFlow
      sink(taintedSubst.replace("input")); // $hasTaintFlow
      sink(taintedSubst.replace("input", 0, 0)); // $hasTaintFlow
      sink(taintedSubst.replace("input".toCharArray())); // $hasTaintFlow
      sink(taintedSubst.replace("input".toCharArray(), 0, 0)); // $hasTaintFlow
      sink(taintedSubst.replace((CharSequence)"input")); // $hasTaintFlow
      sink(taintedSubst.replace((CharSequence)"input", 0, 0)); // $hasTaintFlow
      sink(taintedSubst.replace(new TextStringBuilder("input"))); // $hasTaintFlow
      sink(taintedSubst.replace(new TextStringBuilder("input"), 0, 0)); // $hasTaintFlow
      sink(taintedSubst.replace(new StringBuilder("input"))); // $hasTaintFlow
      sink(taintedSubst.replace(new StringBuilder("input"), 0, 0)); // $hasTaintFlow
      sink(taintedSubst.replace(new StringBuffer("input"))); // $hasTaintFlow
      sink(taintedSubst.replace(new StringBuffer("input"), 0, 0)); // $hasTaintFlow

      // Test replace overloads (tainted input):
      StringSubstitutor untaintedSubst = ss1;
      sink(untaintedSubst.replace((Object)taint())); // $hasTaintFlow
      sink(untaintedSubst.replace(taint())); // $hasTaintFlow
      sink(untaintedSubst.replace(taint(), 0, 0)); // $hasTaintFlow
      sink(untaintedSubst.replace(taint().toCharArray())); // $hasTaintFlow
      sink(untaintedSubst.replace(taint().toCharArray(), 0, 0)); // $hasTaintFlow
      sink(untaintedSubst.replace((CharSequence)taint())); // $hasTaintFlow
      sink(untaintedSubst.replace((CharSequence)taint(), 0, 0)); // $hasTaintFlow
      sink(untaintedSubst.replace(new TextStringBuilder(taint()))); // $hasTaintFlow
      sink(untaintedSubst.replace(new TextStringBuilder(taint()), 0, 0)); // $hasTaintFlow
      sink(untaintedSubst.replace(new StringBuilder(taint()))); // $hasTaintFlow
      sink(untaintedSubst.replace(new StringBuilder(taint()), 0, 0)); // $hasTaintFlow
      sink(untaintedSubst.replace(new StringBuffer(taint()))); // $hasTaintFlow
      sink(untaintedSubst.replace(new StringBuffer(taint()), 0, 0)); // $hasTaintFlow

      // Test static replace methods:
      sink(StringSubstitutor.replace(taint(), new HashMap<String, String>())); // $hasTaintFlow
      sink(StringSubstitutor.replace(taint(), new HashMap<String, String>(), "{", "}")); // $hasTaintFlow
      sink(StringSubstitutor.replace("input", taintedMap)); // $hasTaintFlow
      sink(StringSubstitutor.replace("input", taintedMap, "{", "}")); // $hasTaintFlow
      Properties taintedProps = new Properties();
      taintedProps.put("key", taint());
      sink(StringSubstitutor.replace(taint(), new Properties())); // $hasTaintFlow
      sink(StringSubstitutor.replace("input", taintedProps)); // $hasTaintFlow

      // Test replaceIn methods:
      TextStringBuilder strBuilder1 = new TextStringBuilder(); taintedSubst.replaceIn(strBuilder1); sink(strBuilder1.toString()); // $hasTaintFlow
      TextStringBuilder strBuilder2 = new TextStringBuilder(); taintedSubst.replaceIn(strBuilder2, 0, 0); sink(strBuilder2.toString()); // $hasTaintFlow
      StringBuilder stringBuilder1 = new StringBuilder(); taintedSubst.replaceIn(stringBuilder1); sink(stringBuilder1.toString()); // $hasTaintFlow
      StringBuilder stringBuilder2 = new StringBuilder(); taintedSubst.replaceIn(stringBuilder2, 0, 0); sink(stringBuilder2.toString()); // $hasTaintFlow
      StringBuffer stringBuffer1 = new StringBuffer(); taintedSubst.replaceIn(stringBuffer1); sink(stringBuffer1.toString()); // $hasTaintFlow
      StringBuffer stringBuffer2 = new StringBuffer(); taintedSubst.replaceIn(stringBuffer2, 0, 0); sink(stringBuffer2.toString()); // $hasTaintFlow
    }

}
