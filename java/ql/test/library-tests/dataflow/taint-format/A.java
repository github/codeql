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
        String.format("%s", good);
        String.format("%s %s %s %s %s %s %s %s %s %s ", "a", "a", "a", "a", "a", "a", "a", "a", "a", bad);
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

    public static void test4() {
        String bad = taint();
        StringBuilder sb = new StringBuilder();

        sb.append(bad);

        new Formatter(sb).format("ok").toString();
    }
}