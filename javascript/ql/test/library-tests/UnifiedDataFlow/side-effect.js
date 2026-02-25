import 'dummy';

function t1() {
    function change(x) {
        x.foo = source('t1.1');
    }
    const o = {};
    change(o);
    sink(o.foo); // $ hasValueFlow=t1.1
}

function t2() {
    class C {
        constructor() {
            this.foo = source('t2.1');
        }
    }
    const o = new C();
    sink(o.foo); // $ hasValueFlow=t2.1
}

function t3() {
    class C {
        foo = source('t3.1');
    }
    const o = new C();
    sink(o.foo); // $ hasValueFlow=t3.1
}

function t4() {
    function change(x) {
        x.foo = source('t4.1');
    }
    function change2(safe, x) {
        change(x);
    }
    const o1 = {};
    const o2 = {};
    change2(o1, o2);
    sink(o1.foo); // no flow here
    sink(o2.foo); // $ hasValueFlow=t4.1
}

function t5() {
    class C {
        foo = source('t5.1');
    }
    class D extends C {
        constructor() {
            super();
        }
    }
    const o = new D();
    sink(o.foo); // $ hasValueFlow=t5.1
}

function t6() {
    class C {
        foo = source('t6.1');
    }
    class D extends C {
    }
    const o = new D();
    sink(o.foo); // $ hasValueFlow=t6.1
}

function t7() {
    class C {
        foo = source('t7.1');
    }
    class D extends C {
    }
    sink(new D().foo); // $ hasValueFlow=t7.1
}
