class C1 {
    test() {
        this.f = x;
        this.f;
    }

    static f() {

    }
}

class C2 {
    static test() {
        this.f = x;
        this.f;
    }

    f() {

    }
}

class C3 {
    test() {
        this.f;
    }

    static f() {

    }
}
new C3().f = x;

class C4 {
    static test() {
        this.f;
    }

    f() {

    }
}
C4.f = x;

class C5_super {
    f() {

    }
}
class C5 extends C5_super{
    static f() {

    }
    test() {
        this.f;
    }
}

class C6_super {
    f() {

    }
}
class C6 extends C6_super{
    static test() {
        this.f; // $ Alert
    }
}
