import 'dummy';

function t1() {
    const obj = {};

    sink(obj.field);

    obj.field = source('t1.1');
    sink(obj.field); // $ hasValueFlow=t1.1

    obj.field = "safe";
    sink(obj.field); // $ SPURIOUS: hasValueFlow=t1.1

    obj.field = source('t1.2');
    sink(obj.field); // $ hasValueFlow=t1.2 SPURIOUS: hasValueFlow=t1.1
}

function t2() {
    let obj;

    if (Math.random()) {
        obj = {};
        sink(obj.field);
    } else {
        obj = {};
        obj.field = source('t2.1');
        sink(obj.field); // $ hasValueFlow=t2.1
    }
    sink(obj.field); // $ hasValueFlow=t2.1
}

function t3() {
    function inner(obj) {
        sink(obj.foo); // $ hasValueFlow=t3.2 hasValueFlow=t3.1
    }

    inner({foo: source('t3.1')});

    let obj = {};
    obj.foo = source('t3.2');
    inner(obj);
}

function t4() {
    class C {
        constructor(x) {
            this.foo = x;
            sink(this.foo); // $ hasValueFlow=t4.1
        }
    }
    const c = new C(source('t4.1'));
    sink(c.foo); // $ hasValueFlow=t4.1
}

function t5() {
    class C {
        field = source('t5.1')
        constructor() {
            sink(this.field); // $ hasValueFlow=t5.1
        }
    }
    const c = new C();
    sink(c.field); // $ hasValueFlow=t5.1
}


function t6() {
    function invoke(fn) {
        fn();
    }
    class C {
        constructor(x, y) {
            this.x = x;
            invoke(() => {
                this.y = y;
            });

            sink(this.x); // $ hasValueFlow=t6.1
            sink(this.y); // $ hasValueFlow=t6.2

            invoke(() => {
                sink(this.x); // $ hasValueFlow=t6.1
                sink(this.y); // $ hasValueFlow=t6.2
            });

            this.methodLike = function() {
                sink(this.x); // $ hasValueFlow=t6.1
                sink(this.y); // $ hasValueFlow=t6.2
            }
        }
    }
    const c = new C(source('t6.1'), source('t6.2'));
    sink(c.x); // $ hasValueFlow=t6.1
    sink(c.y); // $ hasValueFlow=t6.2
    c.methodLike();
}

function t7() {
    class Base {
        constructor(x) {
            this.field = x;
            sink(this.field); // $ hasTaintFlow=t7.1
        }
    }
    class Sub extends Base {
        constructor(x) {
            super(x + '!');
            sink(this.field); // $ hasTaintFlow=t7.1
        }
    }
    const c = new Sub(source('t7.1'));
    sink(c.field); // $ hasTaintFlow=t7.1
}

function t8() {
    function foo(x) {
        const obj = {};
        obj.field = x;

        sink(obj.field); // $ hasTaintFlow=t8.1

        if (obj) {
            sink(obj.field); // $ hasTaintFlow=t8.1
        } else {
            sink(obj.field);
        }

        if (!obj) {
            sink(obj.field);
        } else {
            sink(obj.field); // $ hasTaintFlow=t8.1
        }

        if (!obj || !obj) {
            sink(obj.field);
        } else {
            sink(obj.field); // $ hasTaintFlow=t8.1
        }
    }

    // The guards used above are specific to taint-tracking, to ensure only taint flows in
    const taint = source('t8.1') + ' taint';
    foo(taint);
}

function t9() { // same as t8 but with a SanitizerGuard that isn't just a variable access
    function foo(x) {
        const obj = {};
        obj.field = x;

        sink(obj.field); // $ hasTaintFlow=t9.1

        if (typeof obj !== "undefined") {
            sink(obj.field); // $ hasTaintFlow=t9.1
        } else {
            sink(obj.field);
        }

        if (typeof obj === "undefined") {
            sink(obj.field);
        } else {
            sink(obj.field); // $ hasTaintFlow=t9.1
        }

        if (typeof obj === "undefined" || typeof obj === "undefined") {
            // The shared SSA library expects short-circuiting operators be pre-order in the CFG,
            // but in JS they are post-order (as per evaluation order).
            sink(obj.field); // $ SPURIOUS: hasTaintFlow=t9.1
        } else {
            sink(obj.field); // $ hasTaintFlow=t9.1
        }
    }

    // The guards used above are specific to taint-tracking, to ensure only taint flows in
    const taint = source('t9.1') + ' taint';
    foo(taint);
}
