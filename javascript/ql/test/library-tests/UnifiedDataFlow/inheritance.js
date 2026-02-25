function t1() {
    class Base {
        x = source('t1.1');
    }
    class Derived extends Base {}
    sink(new Derived().x); // $ hasValueFlow=t1.1
}

function t2() {
    class Base {
        constructor() {
            this.x = source('t2.1');
        }
    }
    class Derived extends Base {}
    sink(new Derived().x); // $ hasValueFlow=t2.1
}

function t3() {
    class Base {
        x = source('t3.1');

        constructor() {
            this.y = source('t3.2');
        }
    }
    class Derived extends Base {
        z = sink(this.x); // $ hasValueFlow=t3.1
        w = sink(this.y); // $ hasValueFlow=t3.2
    }
    class Derived2 extends Base {
        constructor() {
            super();
            sink(this.x); // $ hasValueFlow=t3.1
            sink(this.y); // $ hasValueFlow=t3.2
        }
    }
}

function t4() {
    class C1 {
        foo() {
            return source('C1.foo');
        }
        baz() {
            return source('C1.baz');
        }
    }
    class C2 extends C1 {
        foo() {
            return source('C2.foo');
        }
        bar() {
            return source('C2.bar');
        }
    }
    class C3 extends C2 {
        baz() {
            return source('C3.baz');
        }
    }
    sink(new C1().foo()); // $ hasValueFlow=C1.foo
    sink(new C1().bar()); // not defined
    sink(new C1().baz()); // $ hasValueFlow=C1.baz

    sink(new C2().foo()); // $ hasValueFlow=C2.foo
    sink(new C2().bar()); // $ hasValueFlow=C2.bar
    sink(new C2().baz()); // $ hasValueFlow=C1.baz

    sink(new C3().foo()); // $ hasValueFlow=C2.foo
    sink(new C3().bar()); // $ hasValueFlow=C2.bar
    sink(new C3().baz()); // $ hasValueFlow=C3.baz
}

function t5() {
    class C {
        foo() {
            sink(this.bar()); // $ hasValueFlow=C.bar
        }
        bar() {
            return source('C.bar');
        }
    }
}

function t6() {
    class Base {
        foo() {
            sink(this.bar()); // $ hasValueFlow=Sub.bar
        }
    }
    class Sub extends Base {
        bar() {
            return source('Sub.bar');
        }
    }
}

function t7() {
    function Base() {}
    Base.prototype.foo = function(x) {
        sink(x); // $ hasValueFlow=t7.1
    }

    new Base().foo(source('t7.1'));
}
