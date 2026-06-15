import 'dummy';

class Base {
    baseMethod(x) {
        this.subclassMethod(x);
    }
}

class Subclass1 extends Base {
    work() {
        this.baseMethod(source("sub1"));
    }
    subclassMethod(x) {
        sink(x); // $ hasValueFlow=sub1
    }
}

class Subclass2 extends Base {
    work() {
        this.baseMethod(source("sub2"));
    }
    subclassMethod(x) {
        sink(x); // $ hasValueFlow=sub2
    }
}

class Subclass3 extends Base {
    work() {
        this.baseMethod("safe");
    }
    subclassMethod(x) {
        sink(x);
    }
}
