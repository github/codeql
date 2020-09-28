import java.util.Formatter;
import java.lang.StringBuilder;

class A {
    public static String taint() { return "tainted"; }

    public static void test1() {
        String bad = taint();
        String good = "hi";

        bad.formatted(good);
        good.formatted("a", bad, "b", good);
        String.format("%s%s", bad, good);
    }

    public static void test2() {
        String bad = taint();
        Formatter f = new Formatter();

        f.toString();
        f.format("%s", bad);
        f.toString();
    }

    public static void test3() {
        String bad = taint();
        StringBuilder sb = new StringBuilder();
        Formatter f = new Formatter(sb);

        sb.toString(); // false positive
        f.format("%s", bad);
        sb.toString();
    }
}