import java.util.Formatter;
import java.lang.StringBuilder;

class A {
    public static String source() {
        return "tainted";
    }

    public static void test1() {
        String bad = source(); // $ hasTaintFlow
        String good = "hi";

        bad.formatted(good); // $ hasTaintFlow
        good.formatted("a", bad, "b", good); // $ hasTaintFlow
        String.format("%s%s", bad, good); // $ hasTaintFlow
        String.format("%s", good);
        String.format("%s %s %s %s %s %s %s %s %s %s ", "a", "a", "a", "a", "a", "a", "a", "a", "a", bad); // $ hasTaintFlow
    }

    public static void test2() {
        String bad = source();  // $ hasTaintFlow
        Formatter f = new Formatter();

        f.toString();
        f.format("%s", bad);  // $ hasTaintFlow
        f.toString(); // $ hasTaintFlow
    }

    public static void test3() {
        String bad = source();  // $ hasTaintFlow
        StringBuilder sb = new StringBuilder();
        Formatter f = new Formatter(sb);

        sb.toString(); // $ hasTaintFlow false positive 
        f.format("%s", bad);  // $ hasTaintFlow
        sb.toString(); // $ hasTaintFlow
    }

    public static void test4() {
        String bad = source();  // $ hasTaintFlow
        StringBuilder sb = new StringBuilder();

        sb.append(bad);  // $ hasTaintFlow

        new Formatter(sb).format("ok").toString();  // $ hasTaintFlow
    }
}