package com.google.common.base;

import java.util.Map;
import java.util.HashMap;
import java.util.concurrent.TimeUnit;
import java.util.Set;

class TestBase {
    String taint() { return "tainted"; }

    void sink(Object o) {}

    void test1() {
        String x = taint();

        sink(Strings.padStart(x, 10, ' ')); // $numTaintFlow=1
        sink(Strings.padEnd(x, 10, ' ')); // $numTaintFlow=1
        sink(Strings.repeat(x, 3)); // $numTaintFlow=1
        sink(Strings.emptyToNull(Strings.nullToEmpty(x))); // $numValueFlow=1
        sink(Strings.lenientFormat(x, 3)); // $numTaintFlow=1
        sink(Strings.commonPrefix(x, "abc")); 
        sink(Strings.commonSuffix(x, "cde")); 
        sink(Strings.lenientFormat("%s = %s", x, 3)); // $ numTaintFlow=1
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
        sink(Preconditions.checkNotNull(taint())); // $numValueFlow=1
        sink(Verify.verifyNotNull(taint())); // $numValueFlow=1
    }

    void test5() {
        sink(Ascii.toLowerCase(taint())); // $numTaintFlow=1
        sink(Ascii.toUpperCase(taint())); // $numTaintFlow=1
        sink(Ascii.truncate(taint(), 3, "...")); // $numTaintFlow=1
        sink(Ascii.truncate("abcabcabc", 3, taint())); // $numTaintFlow=1
        sink(CaseFormat.LOWER_CAMEL.to(CaseFormat.UPPER_UNDERSCORE, taint())); // $numTaintFlow=1
        sink(CaseFormat.LOWER_HYPHEN.converterTo(CaseFormat.UPPER_CAMEL).convert(taint())); // $numTaintFlow=1
        sink(CaseFormat.LOWER_UNDERSCORE.converterTo(CaseFormat.LOWER_HYPHEN).reverse().convert(taint())); // $numTaintFlow=1
    }

    void test6() {
        sink(Suppliers.memoize(Suppliers.memoizeWithExpiration(Suppliers.synchronizedSupplier(Suppliers.ofInstance(taint())), 3, TimeUnit.HOURS)).get()); // $numTaintFlow=1
    }

    void test7() {
        sink(MoreObjects.firstNonNull(taint(), taint())); // $numValueFlow=2
        sink(MoreObjects.firstNonNull(null, taint())); // $numValueFlow=1
        sink(MoreObjects.firstNonNull(taint(), null)); // $numValueFlow=1
        sink(MoreObjects.toStringHelper(taint()).add("x", 3).omitNullValues().toString()); // $numTaintFlow=1
        sink(MoreObjects.toStringHelper((Object) taint()).toString());
        sink(MoreObjects.toStringHelper("a").add("x", 3).add(taint(), 4).toString()); // $numTaintFlow=1
        sink(MoreObjects.toStringHelper("a").add("x", taint()).toString()); // $numTaintFlow=1
        sink(MoreObjects.toStringHelper("a").addValue(taint()).toString()); // $numTaintFlow=1
        MoreObjects.ToStringHelper h = MoreObjects.toStringHelper("a");
        h.add("x", 3).add(taint(), 4);
        sink(h.add("z",5).toString()); // $numTaintFlow=1
    }

    void test8() {
        Optional<String> x = Optional.of(taint());
        sink(x); // no flow
        sink(x.get()); // $numValueFlow=1
        sink(x.or("hi")); // $numValueFlow=1
        sink(x.orNull()); // $numValueFlow=1
        sink(x.asSet().toArray()[0]); // $numValueFlow=1
        sink(Optional.fromJavaUtil(x.toJavaUtil()).get()); // $numValueFlow=1
        sink(Optional.fromJavaUtil(Optional.toJavaUtil(x)).get()); // $numValueFlow=1
        sink(Optional.fromNullable(taint()).get()); // $numValueFlow=1
        sink(Optional.absent().or(x).get()); // $numValueFlow=1
        sink(Optional.absent().or(taint())); // $numValueFlow=1
        sink(Optional.presentInstances(Set.of(x)).iterator().next()); // $numValueFlow=1
    }
}
