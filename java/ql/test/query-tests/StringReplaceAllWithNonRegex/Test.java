public class Test {
    void f() {
        String s1 = "test";
        s1 = s1.replaceAll("t", "x"); // $ Alert
        s1 = s1.replaceAll(".*", "x");
    }
}
