import * as dummy from 'dummy';

function testGetterSource() {
    class C {
        get x() {
            return source();
        }
    };
    sink(new C().x); // NOT OK

    function indirection(c) {
        if (c) {
            sink(c.x); // NOT OK
        }
    }
    indirection(new C());
    indirection(null);
}

function testSetterSink() {
    class C {
        set x(v) {
            sink(v); // NOT OK
        }
    };
    function indirection(c) {
        c.x = source();
    }
    indirection(new C());
    indirection(null);
}

function testFlowThroughGetter() {
    class C {
        constructor(x) {
            this._x = x;
        }

        get x() {
            return this._x;
        }
    };

    function indirection(c) {
        sink(c.x); // NOT OK
    }
    indirection(new C(source()));
    indirection(null);

    function getX(c) {
        return c.x;
    }
    sink(getX(new C(source()))); // NOT OK
    sink(getX(new C(source()))); // NOT OK
}
