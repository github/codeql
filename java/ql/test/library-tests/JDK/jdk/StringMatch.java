public class StringMatch {
    private static String STR = "the quick brown fox jumps over the lazy dog";

    void a() {
        STR.matches("[a-z]+");
    }

    void b() {
        STR.contains("the");
    }

    void c() {
        STR.startsWith("the");
    }

    void d() {
        STR.endsWith("dog");
    }

    void e() {
        STR.indexOf("lazy");
    }

    void f() {
        STR.lastIndexOf("lazy");
    }

    void g() {
        STR.regionMatches(0, "fox", 0, 4);
    }

    void h() {
        STR.regionMatches(true, 0, "FOX", 0, 4);
    }
}
