public class Test {
    void f() throws Throwable {
        // NON_COMPLIANT
        this.finalize(); // $ Alert
    }

    void f1() throws Throwable {
        f(); // COMPLIANT
    }

    @Override
    protected void finalize() throws Throwable {
        // COMPLIANT: If a subclass overrides `finalize()`
        // it must invoke the superclass finalizer explicitly.
        super.finalize();
    }

    // Overload of `finalize`
    protected void finalize(String s) throws Throwable {
        // ...
    }

    void f2() throws Throwable {
        // COMPLIANT: call to overload of `finalize`
        this.finalize("overload");
    }

}
