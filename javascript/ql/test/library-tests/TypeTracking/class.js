class Foo {
    foo() {} // name: foo

    bar() {
        this.foo; // track: foo
    }
}