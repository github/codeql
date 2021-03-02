import org.apache.commons.text.TextStringBuilder;
import org.apache.commons.text.matcher.StringMatcher;
import org.apache.commons.text.StringTokenizer;
import java.io.StringReader;
import java.nio.CharBuffer;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

class TextStringBuilderTest {
    String taint() { return "tainted"; }

    void sink(Object o) {}

    void test() throws Exception {

        TextStringBuilder cons1 = new TextStringBuilder(taint()); sink(cons1.toString()); // $hasTaintFlow=y
        TextStringBuilder cons2 = new TextStringBuilder((CharSequence)taint()); sink(cons2.toString()); // $hasTaintFlow=y

        TextStringBuilder sb1 = new TextStringBuilder(); sb1.append(taint().toCharArray()); sink(sb1.toString()); // $hasTaintFlow=y
        TextStringBuilder sb2 = new TextStringBuilder(); sb2.append(taint().toCharArray(), 0, 0); sink(sb2.toString()); // $hasTaintFlow=y
        TextStringBuilder sb3 = new TextStringBuilder(); sb3.append(CharBuffer.wrap(taint().toCharArray())); sink(sb3.toString()); // $ MISSING: hasTaintFlow=y
        TextStringBuilder sb4 = new TextStringBuilder(); sb4.append(CharBuffer.wrap(taint().toCharArray()), 0, 0); sink(sb4.toString()); // $ MISSING: hasTaintFlow=y
        TextStringBuilder sb5 = new TextStringBuilder(); sb5.append((CharSequence)taint()); sink(sb5.toString()); // $hasTaintFlow=y
        TextStringBuilder sb6 = new TextStringBuilder(); sb6.append((CharSequence)taint(), 0, 0); sink(sb6.toString()); // $hasTaintFlow=y
        TextStringBuilder sb7 = new TextStringBuilder(); sb7.append((Object)taint()); sink(sb7.toString()); // $hasTaintFlow=y
        {
            TextStringBuilder auxsb = new TextStringBuilder(); auxsb.append(taint());
            TextStringBuilder sb8 = new TextStringBuilder(); sb8.append(auxsb); sink(sb8.toString()); // $hasTaintFlow=y
        }
        TextStringBuilder sb9 = new TextStringBuilder(); sb9.append(new StringBuffer(taint())); sink(sb9.toString()); // $hasTaintFlow=y
        TextStringBuilder sb10 = new TextStringBuilder(); sb10.append(new StringBuffer(taint()), 0, 0); sink(sb10.toString()); // $hasTaintFlow=y
        TextStringBuilder sb11 = new TextStringBuilder(); sb11.append(new StringBuilder(taint())); sink(sb11.toString()); // $hasTaintFlow=y
        TextStringBuilder sb12 = new TextStringBuilder(); sb12.append(new StringBuilder(taint()), 0, 0); sink(sb12.toString()); // $hasTaintFlow=y
        TextStringBuilder sb13 = new TextStringBuilder(); sb13.append(taint()); sink(sb13.toString()); // $hasTaintFlow=y
        TextStringBuilder sb14 = new TextStringBuilder(); sb14.append(taint(), 0, 0); sink(sb14.toString()); // $hasTaintFlow=y
        TextStringBuilder sb15 = new TextStringBuilder(); sb15.append(taint(), "format", "args"); sink(sb15.toString()); // $hasTaintFlow=y
        TextStringBuilder sb16 = new TextStringBuilder(); sb16.append("Format string", taint(), "args"); sink(sb16.toString()); // $hasTaintFlow=y
        {
            List<String> taintedList = new ArrayList<>();
            taintedList.add(taint());
            TextStringBuilder sb17 = new TextStringBuilder(); sb17.appendAll(taintedList); sink(sb17.toString()); // $hasTaintFlow=y
            TextStringBuilder sb18 = new TextStringBuilder(); sb18.appendAll(taintedList.iterator()); sink(sb18.toString()); // $hasTaintFlow=y
        }
        TextStringBuilder sb19 = new TextStringBuilder(); sb19.appendAll("clean", taint()); sink(sb19.toString()); // $hasTaintFlow=y
        TextStringBuilder sb20 = new TextStringBuilder(); sb20.appendAll(taint(), "clean"); sink(sb20.toString()); // $hasTaintFlow=y
        TextStringBuilder sb21 = new TextStringBuilder(); sb21.appendFixedWidthPadLeft(taint(), 0, ' '); sink(sb21.toString()); // $hasTaintFlow=y
        TextStringBuilder sb22 = new TextStringBuilder(); sb22.appendFixedWidthPadRight(taint(), 0, ' '); sink(sb22.toString()); // $hasTaintFlow=y
        TextStringBuilder sb23 = new TextStringBuilder(); sb23.appendln(taint().toCharArray()); sink(sb23.toString()); // $hasTaintFlow=y
        TextStringBuilder sb24 = new TextStringBuilder(); sb24.appendln(taint().toCharArray(), 0, 0); sink(sb24.toString()); // $hasTaintFlow=y
        TextStringBuilder sb25 = new TextStringBuilder(); sb25.appendln((Object)taint()); sink(sb25.toString()); // $hasTaintFlow=y
        {
            TextStringBuilder auxsb = new TextStringBuilder(); auxsb.appendln(taint());
            TextStringBuilder sb26 = new TextStringBuilder(); sb26.appendln(auxsb); sink(sb26.toString()); // $hasTaintFlow=y
        }
        TextStringBuilder sb27 = new TextStringBuilder(); sb27.appendln(new StringBuffer(taint())); sink(sb27.toString()); // $hasTaintFlow=y
        TextStringBuilder sb28 = new TextStringBuilder(); sb28.appendln(new StringBuffer(taint()), 0, 0); sink(sb28.toString()); // $hasTaintFlow=y
        TextStringBuilder sb29 = new TextStringBuilder(); sb29.appendln(new StringBuilder(taint())); sink(sb29.toString()); // $hasTaintFlow=y
        TextStringBuilder sb30 = new TextStringBuilder(); sb30.appendln(new StringBuilder(taint()), 0, 0); sink(sb30.toString()); // $hasTaintFlow=y
        TextStringBuilder sb31 = new TextStringBuilder(); sb31.appendln(taint()); sink(sb31.toString()); // $hasTaintFlow=y
        TextStringBuilder sb32 = new TextStringBuilder(); sb32.appendln(taint(), 0, 0); sink(sb32.toString()); // $hasTaintFlow=y
        TextStringBuilder sb33 = new TextStringBuilder(); sb33.appendln(taint(), "format", "args"); sink(sb33.toString()); // $hasTaintFlow=y
        TextStringBuilder sb34 = new TextStringBuilder(); sb34.appendln("Format string", taint(), "args"); sink(sb34.toString()); // $hasTaintFlow=y
        TextStringBuilder sb35 = new TextStringBuilder(); sb35.appendSeparator(taint()); sink(sb35.toString()); // $hasTaintFlow=y
        TextStringBuilder sb36 = new TextStringBuilder(); sb36.appendSeparator(taint(), 0); sink(sb36.toString()); // $hasTaintFlow=y
        TextStringBuilder sb37 = new TextStringBuilder(); sb37.appendSeparator(taint(), "default"); sink(sb37.toString()); // $hasTaintFlow=y
        TextStringBuilder sb38 = new TextStringBuilder(); sb38.appendSeparator("", taint()); sink(sb38.toString()); // $hasTaintFlow=y
        {
            TextStringBuilder auxsb = new TextStringBuilder(); auxsb.appendln(taint());
            TextStringBuilder sb39 = new TextStringBuilder(); auxsb.appendTo(sb39); sink(sb39.toString()); // $hasTaintFlow=y
        }
        {
            List<String> taintedList = new ArrayList<>();
            taintedList.add(taint());
            TextStringBuilder sb40 = new TextStringBuilder(); sb40.appendWithSeparators(taintedList, ", "); sink(sb40.toString()); // $hasTaintFlow=y
            TextStringBuilder sb41 = new TextStringBuilder(); sb41.appendWithSeparators(taintedList.iterator(), ", "); sink(sb41.toString()); // $hasTaintFlow=y
            List<String> untaintedList = new ArrayList<>();
            TextStringBuilder sb42 = new TextStringBuilder(); sb42.appendWithSeparators(untaintedList, taint()); sink(sb42.toString()); // $hasTaintFlow=y
            TextStringBuilder sb43 = new TextStringBuilder(); sb43.appendWithSeparators(untaintedList.iterator(), taint()); sink(sb43.toString()); // $hasTaintFlow=y
            String[] taintedArray = new String[] { taint() };
            String[] untaintedArray = new String[] {};
            TextStringBuilder sb44 = new TextStringBuilder(); sb44.appendWithSeparators(taintedArray, ", "); sink(sb44.toString()); // $hasTaintFlow=y
            TextStringBuilder sb45 = new TextStringBuilder(); sb45.appendWithSeparators(untaintedArray, taint()); sink(sb45.toString()); // $hasTaintFlow=y
        }
        {
            TextStringBuilder sb46 = new TextStringBuilder(); sb46.append(taint());
            char[] target = new char[100];
            sb46.asReader().read(target);
            sink(target); // $hasTaintFlow=y
        }
        TextStringBuilder sb47 = new TextStringBuilder(); sb47.append(taint()); sink(sb47.asTokenizer().next()); // $hasTaintFlow=y
        TextStringBuilder sb48 = new TextStringBuilder(); sb48.append(taint()); sink(sb48.build()); // $hasTaintFlow=y
        TextStringBuilder sb49 = new TextStringBuilder(); sb49.append(taint()); sink(sb49.getChars(null)); // $hasTaintFlow=y
        {
            TextStringBuilder sb50 = new TextStringBuilder(); sb50.append(taint());
            char[] target = new char[100];
            sb50.getChars(target);
            sink(target); // $hasTaintFlow=y
        }
        {
            TextStringBuilder sb51 = new TextStringBuilder(); sb51.append(taint());
            char[] target = new char[100];
            sb51.getChars(0, 0, target, 0);
            sink(target); // $hasTaintFlow=y
        }
        TextStringBuilder sb52 = new TextStringBuilder(); sb52.insert(0, taint().toCharArray()); sink(sb52.toString()); // $hasTaintFlow=y
        TextStringBuilder sb53 = new TextStringBuilder(); sb53.insert(0, taint().toCharArray(), 0, 0); sink(sb53.toString()); // $hasTaintFlow=y
        TextStringBuilder sb54 = new TextStringBuilder(); sb54.insert(0, taint()); sink(sb54.toString()); // $hasTaintFlow=y
        TextStringBuilder sb55 = new TextStringBuilder(); sb55.insert(0, (Object)taint()); sink(sb55.toString()); // $hasTaintFlow=y
        TextStringBuilder sb56 = new TextStringBuilder(); sb56.append(taint()); sink(sb56.leftString(0)); // $hasTaintFlow=y
        TextStringBuilder sb57 = new TextStringBuilder(); sb57.append(taint()); sink(sb57.midString(0, 0)); // $hasTaintFlow=y
        {
            StringReader reader = new StringReader(taint());
            TextStringBuilder sb58 = new TextStringBuilder(); sb58.readFrom(reader); sink(sb58.toString()); // $hasTaintFlow=y
        }
        TextStringBuilder sb59 = new TextStringBuilder(); sb59.replace(0, 0, taint()); sink(sb59.toString()); // $hasTaintFlow=y
        TextStringBuilder sb60 = new TextStringBuilder(); sb60.replace(null, taint(), 0, 0, 0); sink(sb60.toString()); // $hasTaintFlow=y
        TextStringBuilder sb61 = new TextStringBuilder(); sb61.replaceAll((StringMatcher)null, taint()); sink(sb61.toString()); // $hasTaintFlow=y
        TextStringBuilder sb62 = new TextStringBuilder(); sb62.replaceAll("search", taint()); sink(sb62.toString()); // $hasTaintFlow=y
        TextStringBuilder sb63 = new TextStringBuilder(); sb63.replaceAll(taint(), "replace"); sink(sb63.toString()); // GOOD (search string doesn't convey taint)
        TextStringBuilder sb64 = new TextStringBuilder(); sb64.replaceFirst((StringMatcher)null, taint()); sink(sb64.toString()); // $hasTaintFlow=y
        TextStringBuilder sb65 = new TextStringBuilder(); sb65.replaceFirst("search", taint()); sink(sb65.toString()); // $hasTaintFlow=y
        TextStringBuilder sb66 = new TextStringBuilder(); sb66.replaceFirst(taint(), "replace"); sink(sb66.toString()); // GOOD (search string doesn't convey taint)
        TextStringBuilder sb67 = new TextStringBuilder(); sb67.append(taint()); sink(sb67.rightString(0)); // $hasTaintFlow=y
        TextStringBuilder sb68 = new TextStringBuilder(); sb68.append(taint()); sink(sb68.subSequence(0, 0)); // $hasTaintFlow=y
        TextStringBuilder sb69 = new TextStringBuilder(); sb69.append(taint()); sink(sb69.substring(0)); // $hasTaintFlow=y
        TextStringBuilder sb70 = new TextStringBuilder(); sb70.append(taint()); sink(sb70.substring(0, 0)); // $hasTaintFlow=y
        TextStringBuilder sb71 = new TextStringBuilder(); sb71.append(taint()); sink(sb71.toCharArray()); // $hasTaintFlow=y
        TextStringBuilder sb72 = new TextStringBuilder(); sb72.append(taint()); sink(sb72.toCharArray(0, 0)); // $hasTaintFlow=y
        TextStringBuilder sb73 = new TextStringBuilder(); sb73.append(taint()); sink(sb73.toStringBuffer()); // $hasTaintFlow=y
        TextStringBuilder sb74 = new TextStringBuilder(); sb74.append(taint()); sink(sb74.toStringBuilder()); // $hasTaintFlow=y
    }

}