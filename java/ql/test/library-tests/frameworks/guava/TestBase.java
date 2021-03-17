package com.google.common.base;

import java.util.Map;
import java.util.HashMap;

class TestBase {
    String taint() { return "tainted"; }

    void sink(Object o) {}

    void test1() {
        String x = taint();

        sink(Strings.padStart(x, 10, ' ')); // $numTaintFlow=1
        sink(Strings.padEnd(x, 10, ' ')); // $numTaintFlow=1
        sink(Strings.repeat(x, 3)); // $numTaintFlow=1
        sink(Strings.emptyToNull(Strings.nullToEmpty(x))); // $numTaintFlow=1
        sink(Strings.lenientFormat(x, 3)); // $numTaintFlow=1
        sink(Strings.commonPrefix(x, "abc")); 
        sink(Strings.commonSuffix(x, "cde")); 
        sink(Strings.lenientFormat("%s = %s", x, 3)); // $numTaintFlow=1
    }

    void test2() {
        String x = taint();
        Splitter s = Splitter.on(x).omitEmptyStrings();

        sink(s.split("x y z"));
        sink(s.split(x)); // $numTaintFlow=1
        sink(s.splitToList(x)); // $numTaintFlow=1
        sink(s.withKeyValueSeparator("=").split("a=b"));
        sink(s.withKeyValueSeparator("=").split(x)); // $numTaintFlow=1
    }

    void test3() {
        String x = taint();
        Joiner taintedJoiner = Joiner.on(x);
        Joiner safeJoiner = Joiner.on(", ");

        StringBuilder sb = new StringBuilder();
        sink(safeJoiner.appendTo(sb, "a", "b", "c"));
        sink(sb.toString());
        sink(taintedJoiner.appendTo(sb, "a", "b", "c")); // $numTaintFlow=1
        sink(sb.toString()); // $numTaintFlow=1
        sink(safeJoiner.appendTo(sb, "a", "b", "c")); // $numTaintFlow=1
        sink(sb.toString()); // $numTaintFlow=1

        sb = new StringBuilder();
        sink(safeJoiner.appendTo(sb, x, x)); // $numTaintFlow=1

        Map<String, String> m = new HashMap<String, String>();
        m.put("k", "v");
        sink(safeJoiner.withKeyValueSeparator("=").join(m));
        sink(safeJoiner.withKeyValueSeparator(x).join(m)); // $numTaintFlow=1
        sink(taintedJoiner.useForNull("(null)").withKeyValueSeparator("=").join(m)); // $numTaintFlow=1
        m.put("k2", x);
        sink(safeJoiner.withKeyValueSeparator("=").join(m)); // $numTaintFlow=1
    }

    void test4() {
        sink(Preconditions.checkNotNull(taint())); // $numTaintFlow=1
    }
}