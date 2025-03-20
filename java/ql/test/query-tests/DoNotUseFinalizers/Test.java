public class Test {
    void f() throws Throwable {
        System.gc(); // NON_COMPLIANT
        Runtime.getRuntime().gc(); // NON_COMPLIANT
        this.finalize(); // NON_COMPLIANT
        // this is removed in Java 11
        //System.runFinalizersOnExit(true); // NON_COMPLIANT
    }

    void f1() throws Throwable {
        f(); // COMPLIANT
    }
}
