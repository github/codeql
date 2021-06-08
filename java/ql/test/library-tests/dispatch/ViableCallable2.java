
class ViableCallable2 {
    private void f(A x) {
        x.m();
    }

    public void g() {
        A arg = new B();
        f(arg);
    }

    public void h(A a) {
        a.m();
        if (a instanceof B) {
            a.m();
        } else {
            a.m();
        }
    }
}

class A {
    public void m() { throw new Error(); }
}

class B extends A {
    @Override
    public void m() { throw new Error(); }
}
