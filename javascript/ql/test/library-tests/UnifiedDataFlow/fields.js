function t1() {
    class C {
        static x = source('t1.1');
    }
    sink(C.x); // $ hasValueFlow=t1.1
}

function t2() {
    class C {
        static x = source('t2.1');
        static y = sink(C.x); // $ hasValueFlow=t2.1
    }
}

function t3() {
    class C {
        static y = sink(C.x); // no flow
        static x = source('t3.1');
    }
}

function t4() {
    class C {
        x = source('t4.1');
    }
    sink(C.x); // no flow
    sink(new C().x); // $ hasValueFlow=t4.1
}

function t5() {
    class C {
        constructor() {
            this.x = source('t5.1');
        }
    }
    sink(C.x); // no flow
    sink(new C().x); // $ hasValueFlow=t5.1
}

function t6() {
    class C {
        a = sink(this.x); // no flow
        x = source('t6.1');
        y = sink(this.x); // $ hasValueFlow=t6.1
        z = this.x;
        w = sink(this.z); // $ hasValueFlow=t6.1
    }
    sink(new C().z); // $ hasValueFlow=t6.1
}

function t7() {
    class C {
        x = source('t7.1');
        constructor() {
            sink(this.x); // $ hasValueFlow=t7.1
        }
    }
}
