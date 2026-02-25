import 'dummy';

function identity(t) {
    return t;
}
class C {
    foo(x) {
        return x;
    }
    self() {
        return this;
    }
}

const c = new C();
sink(c.foo(source('t.1'))); // $ hasValueFlow=t.1
sink(identity(c).foo(source('t.2'))); // $ hasValueFlow=t.2
sink(c.self().foo(source('t.3'))); // $ hasValueFlow=t.3
