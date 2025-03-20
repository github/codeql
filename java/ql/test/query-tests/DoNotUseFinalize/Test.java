public class Test {
    void f() throws Throwable {
        this.finalize(); // NON_COMPLIANT
    }

    void f1() throws Throwable {
        f(); // COMPLIANT
    }
}
