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
    sink(getX(new C(source()))); // NOT OK - but not flagged
    getX(null);
}

function testFlowThroughObjectLiteralAccessors() {
    let obj = {
        get x() {
            return source();
        },
        set y(value) {
            sink(value); // NOT OK
        }
    };
    sink(obj.x); // NOT OK
    obj.y = source();

    function indirection(c) {
        sink(c.x); // NOT OK - but not currently flagged
    }
    indirection(obj);
    indirection(null);
}

function testFlowThroughSubclass() {
    class Base {
        get x() {
            return source();
        }
        set y(value) {
            sink(value); // NOT OK
        }
    };
    class C extends Base {
    }

    sink(new C().x); // NOT OK
    new C().y = source();

    function indirection(c) {
        sink(c.x); // NOT OK
    }
    indirection(new C());
    indirection(null);

    function getX(c) {
        return c.x;
    }
    sink(getX(new C())); // NOT OK - but not flagged
    getX(null);
}
