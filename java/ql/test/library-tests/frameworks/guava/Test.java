
import com.google.common.base.Strings;
import com.google.common.base.Splitter;
import com.google.common.base.Joiner;

import java.util.Map;
import java.util.HashMap;

class Test {
    String taint() { return "tainted"; }

    void test1() {
        String x = taint();

        Strings.padStart(x, 10, ' ');
        Strings.padEnd(x, 10, ' ');
        Strings.repeat(x, 3);
        Strings.emptyToNull(Strings.nullToEmpty(x));
        Strings.lenientFormat(x, 3);
        Strings.commonPrefix(x, "abc");
        Strings.commonSuffix(x, "cde");
        Strings.lenientFormat("%s = %s", x, 3);
    }

    void test2() {
        String x = taint();
        Splitter s = Splitter.on(x).omitEmptyStrings();

        s.split("x y z");
        s.split(x);
        s.splitToList(x);
        s.withKeyValueSeparator("=").split("a=b");
        s.withKeyValueSeparator("=").split(x);
    }

    void test3() {
        String x = taint();
        Joiner j1 = Joiner.on(x);
        Joiner j2 = Joiner.on(", ");

        StringBuilder sb = new StringBuilder();
        j2.appendTo(sb, "a", "b", "c");
        sb.toString();
        j1.appendTo(sb, "a", "b", "c");
        sb.toString();
        j2.appendTo(sb, "a", "b", "c");
        sb.toString();

        sb = new StringBuilder();
        j2.appendTo(sb, x, x);

        Map<String, String> m = new HashMap<String, String>();
        m.put("k", "v");
        j2.withKeyValueSeparator("=").join(m);
        j2.withKeyValueSeparator(x).join(m);
        j1.useForNull("(null)").withKeyValueSeparator("=").join(m);
        m.put("k2", x);
        j2.withKeyValueSeparator("=").join(m);
    }
}