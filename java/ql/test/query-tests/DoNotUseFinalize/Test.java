public class Test {
    void f() throws Throwable {
        // NON_COMPLIANT
        this.finalize(); // $ Alert
    }

    void f1() throws Throwable {
        f(); // COMPLIANT
    }
}
