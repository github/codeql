package com.google.common.collect;

import java.util.Map;
import java.util.SortedSet;
import java.util.SortedMap;
import java.util.Comparator;

class TestCollect {
    String taint() { return "tainted"; }

    void sink(Object o) {}

    void test1() {
        String x = taint();

        ImmutableSet<String> xs = ImmutableSet.of(x, "y", "z");
        sink(xs.asList()); // $numTaintFlow=1

        ImmutableSet<String> ys = ImmutableSet.of("a", "b", "c");

        sink(Sets.filter(Sets.union(xs, ys), y -> true)); // $numTaintFlow=1

        sink(Sets.newHashSet("a", "b", "c", "d", x)); // $numTaintFlow=1
    }

    void test2() {
        sink(ImmutableList.of(taint(), taint(), taint(), taint()));  // $numTaintFlow=4
        sink(ImmutableMap.of(taint(), taint(), taint(), taint()));  // $numTaintFlow=2
        sink(ImmutableMultimap.of(taint(), taint(), taint(), taint()));  // $numTaintFlow=2
        sink(ImmutableTable.of(taint(),taint(), taint()));  // $numTaintFlow=1
    }

    void test3() {
        String x = taint();

        ImmutableList.Builder<String> b = ImmutableList.builder();

        b.add("a");
        sink(b);
        b.add(x);
        sink(b.build()); // $numTaintFlow=1

        b = ImmutableList.builder();

        b.add("a").add(x);
        sink(b.build()); // $numTaintFlow=1

        sink(ImmutableList.builder().add("a").add(x).build()); // $numTaintFlow=1

        ImmutableMap.Builder<String, String> b2 = ImmutableMap.builder();
        b2.put(x,"v");
        sink(b2);
        b2.put("k",x);
        sink(b2.build()); // $numTaintFlow=1
    }

    void test4(Table<String, String, String> t1, Table<String, String, String> t2, Table<String, String, String> t3) {
        String x = taint();
        t1.put(x, "c", "v");
        sink(t1);
        t1.put("r", x, "v");
        sink(t1);
        t1.put("r", "c", x);
        sink(t1); // $numTaintFlow=1
        sink(t1.row("r")); // $numTaintFlow=1
        
        t2.putAll(t1);
        for (Table.Cell<String,String,String> c : t2.cellSet()) {
            sink(c.getValue()); // $numTaintFlow=1
        }

        sink(t1.remove("r", "c")); // $numTaintFlow=1

        t3.row("r").put("c", x);
        sink(t3);  // $ MISSING:numTaintFlow=1
    }

    void test4(Multimap<String, String> m1, Multimap<String, String> m2, Multimap<String, String> m3, 
           Multimap<String, String> m4, Multimap<String, String> m5){
        String x = taint();
        m1.put("k", x);
        sink(m1); // $numTaintFlow=1
        sink(m1.get("k")); // $numTaintFlow=1

        m2.putAll("k", ImmutableList.of("a", x, "b"));
        sink(m2); // $numTaintFlow=1

        m3.putAll(m1);
        sink(m3); // $numTaintFlow=1

        m4.replaceValues("k", m1.replaceValues("k", ImmutableList.of("a")));
        for (Map.Entry<String, String> e : m4.entries()) {
            sink(e.getValue()); // $numTaintFlow=1
        }

        m5.asMap().get("k").add(x);
        sink(m5);  // $ MISSING:numTaintFlow=1
    }

    void test5(Comparator<String> comp, SortedSet<String> sorS, SortedMap<String, String> sorM) {
        ImmutableSortedSet<String> s = ImmutableSortedSet.of(taint());

        sink(s); // $numTaintFlow=1
        sink(ImmutableSortedSet.copyOf(s)); // $numTaintFlow=1
        sink(ImmutableSortedSet.copyOf(comp, s)); // $numTaintFlow=1

        sorS.add(taint());
        sink(ImmutableSortedSet.copyOfSorted(sorS)); // $ MISSING: numTaintFlow=1

        sink(ImmutableList.sortedCopyOf(s)); // $numTaintFlow=1
        sink(ImmutableList.sortedCopyOf(comp, s)); // $numTaintFlow=1

        ImmutableSortedMap<String, String> m = ImmutableSortedMap.of("k", taint());

        sink(m); // $numTaintFlow=1
        sink(ImmutableSortedMap.copyOf(m)); // $numTaintFlow=1
        sink(ImmutableSortedMap.copyOf(m, comp)); // $numTaintFlow=1

        sorM.put("k", taint());
        sink(ImmutableSortedMap.copyOfSorted(sorM)); // $ MISSING: numTaintFlow=1
    }
}
