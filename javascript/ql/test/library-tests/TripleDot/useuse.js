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
