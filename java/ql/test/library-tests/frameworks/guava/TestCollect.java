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
        sink(xs.asList());

        ImmutableSet<String> ys = ImmutableSet.of("a", "b", "c");

        sink(Sets.filter(Sets.union(xs, ys), y -> true));

        sink(Sets.newHashSet("a", "b", "c", "d", x));
    }

    void test2() {
        sink(ImmutableList.of(taint(), taint(), taint(), taint())); // expect 4 alerts
        sink(ImmutableMap.of(taint(), taint(), taint(), taint())); // expect 2 alerts
        sink(ImmutableMultimap.of(taint(), taint(), taint(), taint())); // expect 2 alerts
        sink(ImmutableTable.of(taint(),taint(), taint())); // expect 1 alert
    }

    void test3() {
        String x = taint();

        ImmutableList.Builder<String> b = ImmutableList.builder();

        b.add("a");
        sink(b);
        b.add(x);
        sink(b.build());

        b = ImmutableList.builder();

        b.add("a").add(x);
        sink(b.build());

        sink(ImmutableList.builder().add("a").add(x).build());

        ImmutableMap.Builder<String, String> b2 = ImmutableMap.builder();
        b2.put(x,"v");
        sink(b2);
        b2.put("k",x);
        sink(b2.build());
    }

    void test4(Table<String, String, String> t1, Table<String, String, String> t2, Table<String, String, String> t3) {
        String x = taint();
        t1.put(x, "c", "v");
        sink(t1);
        t1.put("r", x, "v");
        sink(t1);
        t1.put("r", "c", x);
        sink(t1);
        sink(t1.row("r"));
        
        t2.putAll(t1);
        for (Table.Cell<String,String,String> c : t2.cellSet()) {
            sink(c.getValue());
        }

        sink(t1.remove("r", "c"));

        t3.row("r").put("c", x);
        sink(t3); // Not detected
    }

    void test4(Multimap<String, String> m1, Multimap<String, String> m2, Multimap<String, String> m3, 
           Multimap<String, String> m4, Multimap<String, String> m5){
        String x = taint();
        m1.put("k", x);
        sink(m1);
        sink(m1.get("k"));

        m2.putAll("k", ImmutableList.of("a", x, "b"));
        sink(m2);

        m3.putAll(m1);
        sink(m3);

        m4.replaceValues("k", m1.replaceValues("k", ImmutableList.of("a")));
        for (Map.Entry<String, String> e : m4.entries()) {
            sink(e.getValue());
        }

        m5.asMap().get("k").add(x);
        sink(m5); // Not detected
    }

    void test5(Comparator<String> comp, SortedSet<String> sorS, SortedMap<String, String> sorM) {
        ImmutableSortedSet<String> s = ImmutableSortedSet.of(taint());

        sink(s);
        sink(ImmutableSortedSet.copyOf(s));
        sink(ImmutableSortedSet.copyOf(comp, s));

        sorS.add(taint());
        sink(ImmutableSortedSet.copyOfSorted(sorS));

        sink(ImmutableList.sortedCopyOf(s));
        sink(ImmutableList.sortedCopyOf(comp, s));

        ImmutableSortedMap<String, String> m = ImmutableSortedMap.of("k", taint());

        sink(m);
        sink(ImmutableSortedMap.copyOf(m));
        sink(ImmutableSortedMap.copyOf(m, comp));

        sorM.put("k", taint());
        sink(ImmutableSortedMap.copyOfSorted(sorM));
    }
}