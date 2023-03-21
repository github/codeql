import java.util.Formatter;
import java.lang.StringBuilder;

class A {
    public static String source() {
        return "tainted";
    }

    public static void sink(Object o) { }

    public static void test1() {
        String bad = source();
        String good = "hi";

        sink(bad.formatted(good)); // $ hasTaintFlow
        sink(good.formatted("a", bad, "b", good)); // $ hasTaintFlow
        sink(String.format("%s%s", bad, good)); // $ hasTaintFlow
        sink(String.format("%s", good));
        sink(String.format("%s %s %s %s %s %s %s %s %s %s ", "a", "a", "a", "a", "a", "a", "a", "a", "a", bad)); // $ hasTaintFlow
    }

    public static void test2() {
        String bad = source();
        Formatter f = new Formatter();

        sink(f.toString());
        sink(f.format("%s", bad));  // $ hasTaintFlow
        sink(f.toString()); // $ hasTaintFlow
    }

    public static void test3() {
        String bad = source();
        StringBuilder sb = new StringBuilder();
        Formatter f = new Formatter(sb);

        sink(sb.toString()); // $ SPURIOUS: hasTaintFlow
        sink(f.format("%s", bad));  // $ hasTaintFlow
        sink(sb.toString()); // $ hasTaintFlow
    }

    public static void test4() {
        String bad = source();
        StringBuilder sb = new StringBuilder();

        sink(sb.append(bad));  // $ hasTaintFlow

        sink(new Formatter(sb).format("ok").toString());  // $ hasTaintFlow
    }
}
