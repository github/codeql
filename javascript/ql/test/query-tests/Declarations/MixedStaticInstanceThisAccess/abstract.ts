abstract class Q {
    abstract test();
    static test() {}

    method() {
        this.test(); // OK
    }
}
