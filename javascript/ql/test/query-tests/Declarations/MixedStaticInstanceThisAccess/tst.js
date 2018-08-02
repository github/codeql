class C1 {
    test() {
        this.f = x;
        this.f; // OK
    }

    static f() {

    }
}

class C2 {
    static test() {
        this.f = x;
        this.f; // OK
    }

    f() {

    }
}

class C3 {
    test() {
        this.f; // OK
    }

    static f() {

    }
}
new C3().f = x;

class C4 {
    static test() {
        this.f; // OK
    }

    f() {

    }
}
C4.f = x;
