package com.google.common.collect;

import java.util.Collection;
import java.util.Map;
import java.util.SortedSet;
import java.util.SortedMap;
import java.util.Comparator;

class TestCollect {
    String taint() { return "tainted"; }

    void sink(Object o) {}

    <T> T element(Collection<T> c) {
        return c.iterator().next();
    }

    <K,V> K mapKey(Map<K,V> m) {
        return element(m.keySet());
    }

    <K,V> V mapValue(Map<K,V> m) {
        return element(m.values());
    }

    <K,V> K multimapKey(Multimap<K,V> m) {
        return element(m.keySet());
    }

    <K,V> V multimapValue(Multimap<K,V> m) {
        return element(m.values());
    }

    <R,C,V> R tableRow(Table<R,C,V> t) {
        return element(t.rowKeySet());
    }

    <R,C,V> C tableColumn(Table<R,C,V> t) {
        return element(t.columnKeySet());
    }

    <R,C,V> V tableValue(Table<R,C,V> t) {
        return element(t.values());
    }

    void test1() {
        String x = taint();

        ImmutableSet<String> xs = ImmutableSet.of(x, "y", "z");
        sink(element(xs.asList())); // $numValueFlow=1

        ImmutableSet<String> ys = ImmutableSet.of("a", "b", "c");

        sink(element(Sets.filter(Sets.union(xs, ys), y -> true))); // $numValueFlow=1

        sink(element(Sets.newHashSet("a", "b", "c", "d", x))); // $numValueFlow=1
    }

    void test2() {
        sink(element(ImmutableList.of(taint(), taint(), taint(), taint(),taint(), taint(), taint(), taint(),taint(), taint(), taint(), taint(),taint(), taint(), taint(), taint()))); // $numValueFlow=16
        sink(element(ImmutableSet.of(taint(), taint(), taint(), taint(),taint(), taint(), taint(), taint(),taint(), taint(), taint(), taint(),taint(), taint(), taint(), taint()))); // $numValueFlow=16
        sink(mapKey(ImmutableMap.of(taint(), taint(), taint(), taint())));  // $numValueFlow=2
        sink(mapValue(ImmutableMap.of(taint(), taint(), taint(), taint())));  // $numValueFlow=2
        sink(multimapKey(ImmutableMultimap.of(taint(), taint(), taint(), taint())));  // $numValueFlow=2
        sink(multimapValue(ImmutableMultimap.of(taint(), taint(), taint(), taint())));  // $numValueFlow=2
        sink(tableRow(ImmutableTable.of(taint(), taint(), taint())));  // $numValueFlow=1
        sink(tableColumn(ImmutableTable.of(taint(), taint(), taint())));  // $numValueFlow=1
        sink(tableValue(ImmutableTable.of(taint(), taint(), taint())));  // $numValueFlow=1
    }

    void test3() {
        String x = taint();

        ImmutableList.Builder<String> b = ImmutableList.builder();

        b.add("a");
        sink(b);
        b.add(x);
        sink(element(b.build())); // $numValueFlow=1

        b = ImmutableList.builder();

        b.add("a").add(x);
        sink(element(b.build())); // $numValueFlow=1

        sink(ImmutableList.builder().add("a").add(x).build().toArray()[0]); // $numValueFlow=1

        ImmutableMap.Builder<String, String> b2 = ImmutableMap.builder();
        b2.put(x,"v");
        sink(mapKey(b2.build())); // $numValueFlow=1
        b2.put("k",x);
        sink(mapValue(b2.build())); // $numValueFlow=1
    }

    void test4(Table<String, String, String> t1, Table<String, String, String> t2, Table<String, String, String> t3) {
        String x = taint();
        t1.put(x, "c", "v");
        sink(tableRow(t1)); // $numValueFlow=1
        t1.put("r", x, "v");
        sink(tableColumn(t1)); // $numValueFlow=1
        t1.put("r", "c", x);
        sink(tableValue(t1)); // $numValueFlow=1
        sink(mapKey(t1.row("r"))); // $numValueFlow=1
        sink(mapValue(t1.row("r"))); // $numValueFlow=1
        
        t2.putAll(t1);
        for (Table.Cell<String,String,String> c : t2.cellSet()) {
            sink(c.getValue()); // $numValueFlow=1
        }

        sink(t1.remove("r", "c")); // $numValueFlow=1

        t3.row("r").put("c", x);
        sink(tableValue(t3));  // $ MISSING:numValueFlow=1 // depends on aliasing
    }

    void test5(Multimap<String, String> m1, Multimap<String, String> m2, Multimap<String, String> m3, 
           Multimap<String, String> m4, Multimap<String, String> m5){
        String x = taint();
        m1.put("k", x);
        sink(multimapValue(m1)); // $numValueFlow=1
        sink(element(m1.get("k"))); // $numValueFlow=1

        m2.putAll("k", ImmutableList.of("a", x, "b"));
        sink(multimapValue(m2)); // $numValueFlow=1

        m3.putAll(m1);
        sink(multimapValue(m3)); // $numValueFlow=1

        m4.replaceValues("k", m1.replaceValues("k", ImmutableList.of("a")));
        for (Map.Entry<String, String> e : m4.entries()) {
            sink(e.getValue()); // $numValueFlow=1
        }

        m5.asMap().get("k").add(x);
        sink(multimapValue(m5));  // $ MISSING:numValueFlow=1 // depends on aliasing
    }

    void test6(Comparator<String> comp, SortedSet<String> sorS, SortedMap<String, String> sorM) {
        ImmutableSortedSet<String> s = ImmutableSortedSet.of(taint());

        sink(element(s)); // $numValueFlow=1
        sink(element(ImmutableSortedSet.copyOf(s))); // $numValueFlow=1
        sink(element(ImmutableSortedSet.copyOf(comp, s))); // $numValueFlow=1

        sorS.add(taint());
        sink(element(ImmutableSortedSet.copyOfSorted(sorS))); // $numValueFlow=1

        sink(element(ImmutableList.sortedCopyOf(s))); // $numValueFlow=1
        sink(element(ImmutableList.sortedCopyOf(comp, s))); // $numValueFlow=1

        ImmutableSortedMap<String, String> m = ImmutableSortedMap.of("k", taint());

        sink(mapValue(m)); // $numValueFlow=1
        sink(mapValue(ImmutableSortedMap.copyOf(m))); // $numValueFlow=1
        sink(mapValue(ImmutableSortedMap.copyOf(m, comp))); // $numValueFlow=1

        sorM.put("k", taint());
        sink(mapValue(ImmutableSortedMap.copyOfSorted(sorM))); // $numValueFlow=1
    }
}
