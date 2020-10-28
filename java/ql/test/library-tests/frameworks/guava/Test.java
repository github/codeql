
import com.google.common.base.Strings;
import com.google.common.base.Splitter;
import com.google.common.base.Joiner;

import java.util.Map;
import java.util.HashMap;

class Test {
    String taint() { return "tainted"; }

    void sink(Object o) {}

    void test1() {
        String x = taint();

        sink(Strings.padStart(x, 10, ' '));
        sink(Strings.padEnd(x, 10, ' '));
        sink(Strings.repeat(x, 3));
        sink(Strings.emptyToNull(Strings.nullToEmpty(x)));
        sink(Strings.lenientFormat(x, 3));
        sink(Strings.commonPrefix(x, "abc"));
        sink(Strings.commonSuffix(x, "cde"));
        sink(Strings.lenientFormat("%s = %s", x, 3));
    }

    void test2() {
        String x = taint();
        Splitter s = Splitter.on(x).omitEmptyStrings();

        sink(s.split("x y z"));
        sink(s.split(x));
        sink(s.splitToList(x));
        sink(s.withKeyValueSeparator("=").split("a=b"));
        sink(s.withKeyValueSeparator("=").split(x));
    }

    void test3() {
        String x = taint();
        Joiner taintedJoiner = Joiner.on(x);
        Joiner safeJoiner = Joiner.on(", ");

        StringBuilder sb = new StringBuilder();
        sink(safeJoiner.appendTo(sb, "a", "b", "c"));
        sink(sb.toString());
        sink(taintedJoiner.appendTo(sb, "a", "b", "c"));
        sink(sb.toString());
        sink(safeJoiner.appendTo(sb, "a", "b", "c"));
        sink(sb.toString());

        sb = new StringBuilder();
        sink(safeJoiner.appendTo(sb, x, x));

        Map<String, String> m = new HashMap<String, String>();
        m.put("k", "v");
        sink(safeJoiner.withKeyValueSeparator("=").join(m));
        sink(safeJoiner.withKeyValueSeparator(x).join(m));
        sink(taintedJoiner.useForNull("(null)").withKeyValueSeparator("=").join(m));
        m.put("k2", x);
        sink(safeJoiner.withKeyValueSeparator("=").join(m));
    }
}