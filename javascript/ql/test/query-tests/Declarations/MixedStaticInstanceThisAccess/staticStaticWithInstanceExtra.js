class Foo {
    static bar() {
        this.baz; // OK
    }
    static baz() {}
    baz() {}
}
