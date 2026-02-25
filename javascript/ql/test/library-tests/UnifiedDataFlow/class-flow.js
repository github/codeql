import 'dummy';

function t1() {
    class C {
        foo(x) {
            sink(x); // $ hasValueFlow=f1
        }
    }

    function f1(c) {
        c.foo(source("f1"));
    }
    function f2() {
        return new C();
    }
    f1(f2());
}

function t2() {
    class C {
        foo() {
            this.fn = () => source("f2");
        }
        bar() {
            sink(this.fn()); // $ hasValueFlow=f2
        }
    }
}
