import 'dummy';

function t1() {
    class C {
        get x() {
            return source('t1.1');
        }
    }
    sink(new C().x); // $ hasValueFlow=t1.1
    sink(new C().x()); // no flow
}

function t2() {
    class C {
        set x(v) {
            sink(v); // $ hasValueFlow=t2.1
        }
    }
    new C().x = source('t2.1');
    new C().x(source('t2.2')); // no flow
}

function t3() {
    const obj = {
        get x() {
            return source('t3.1');
        }
    };
    sink(obj.x); // $ hasValueFlow=t3.1
}

function t4() {
    const obj = {
        set x(v) {
            sink(v); // $ hasValueFlow=t4.1
        }
    };
    obj.x = source('t4.1');
}

function t5() {
    function C() {}
    C.prototype = {
        get x() {
            return source('t5.1');
        }
    }
    sink(new C().x); // $ MISSING: hasValueFlow=t5.1
}

function t6() {
    function C() {}
    C.prototype = {
        set x(v) {
            sink(v); // $ MISSING: hasValueFlow=t6.1
        }
    }
    new C().x = source('t6.1');
}

function t7() {
    class C {
        get x() {
            return source('t7.1');
        }
        set x(v) {
            sink(v); // $ hasValueFlow=t7.2
        }
    }
    class D extends C {}
    sink(new D().x); // $ hasValueFlow=t7.1
    new D().x = source('t7.2');
}

function t8() {
    class C {
        get x() {
            return this.foo();
        }
        foo() {
            return source('t8.1');
        }
    }
    sink(new C().x); // $ hasValueFlow=t8.1
}

function t9() {
    const captured = source('t9.1');
    class C {
        get x() {
            return captured;
        }
    }
    sink(new C().x); // $ MISSING: hasValueFlow=t9.1
}

function t10() {
    class C {
        constructor(value) {
            this.value = value;
        }
        get x() {
            return this.value;
        }
    }
    const taint = source('t10.1');
    sink(new C(taint).x); // $ hasValueFlow=t10.1
    sink(new C("safe").x); // no flow
}

function t11() {
    class Base {
        foo() {
            return source('t11.1');
        }
    }
    class Sub extends Base {
        get foo() {
            return () => source('t11.2');
        }
    }
    sink(new Sub().foo()); // $ hasValueFlow=t11.2
}

function t12() {
    class C {
        static get foo() {
            return source('t12.1');
        }
        static set foo(v) {
            sink(v); // $ hasValueFlow=t12.2
        }
    }
    sink(C.foo); // $ hasValueFlow=t12.1
    C.foo = source('t12.2');
}
