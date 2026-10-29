public class Test {
    void f() {
        String s1 = "test";
        s1 = s1.replaceAll("t", "x"); // $ Alert // NON_COMPLIANT
        s1 = s1.replaceAll(".*", "x"); // COMPLIANT
        s1 = s1.replace("t", "x"); // COMPLIANT
    }
}
