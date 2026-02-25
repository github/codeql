import 'dummy';

function t1() {
    function simpleCallback(value, callback) {
        callback(value);
    }
    class C {
        foo(x) {
            sink(x); // $ hasValueFlow=t1.1
        }
    }
    class D {
        foo(x) {
            sink(x); // $ hasValueFlow=t1.2
        }
    }
    simpleCallback(
        new C(),
        c => c.foo(source('t1.1'))
    );
    simpleCallback(
        new D(),
        d => d.foo(source('t1.2'))
    );
}

function t2() {
    class C {
        foo(x) {
            sink(x); // $ hasValueFlow=t2.1
        }
    }
    function simpleCallback(callback) {
        callback(new C());
    }
    simpleCallback(c => c.foo(source('t2.1')));
}


function t3() {
    class C {
        foo(x) {
            sink(x); // $ hasValueFlow=t3.1
        }
    }
    function simpleCallback(callback) {
        callback(new C());
    }
    function h() {
        let captured = null;
        simpleCallback(c => { captured = c; });
        return captured;
    }
    h().foo(source('t3.1'));
}

function t4() {
    function customForEach(values, callback) {
        for (let value of values) {
            callback(value);
        }
    }
    class C {
        foo(x) {
            sink(x); // $ MISSING: hasValueFlow=t4.1
        }
    }
    class D {
        foo(x) {
            sink(x); // $ MISSING: hasValueFlow=t4.2
        }
    }
    customForEach(
        [new C()],
        c => c.foo(source('t4.1'))
    );
    customForEach(
        [new D()],
        d => d.foo(source('t4.2'))
    );
}
