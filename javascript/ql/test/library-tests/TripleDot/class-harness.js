import 'dummy';

function h1() {
    class C {
        constructor(arg) {
            this.x = source("h1.1")
        }
        method() {
            sink(this.x); // $ hasValueFlow=h1.1
        }
    }
}

function h2() {
    class C {
        method1() {
            this.x = source("h2.1")
        }
        method2() {
            sink(this.x); // $ hasValueFlow=h2.1
        }
    }
}

function h3() {
    class C {
        constructor(arg) {
            this.x = arg;
        }
        method1() {
            sink(this.x); // $ hasValueFlow=h3.2
        }
        method2() {
            sink(this.x); // $ hasValueFlow=h3.3
        }
    }
    new C(source("h3.1"));
    new C(source("h3.2")).method1();
    new C(source("h3.3")).method2();
}
