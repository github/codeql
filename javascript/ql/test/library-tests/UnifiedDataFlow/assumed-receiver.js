import 'dummy';

function t1() {
    class C {
        foo() {
            const self = this;
            function h() {
                self.bar(source("t1.1"));
            }
        }
        bar(x) {
            sink(x); // $ hasValueFlow=t1.1
        }
    }
}

function t2() {
    function Foo() {}

    Foo.prototype.first = function(x) {
        sink(x); // $ hasValueFlow=t2.1
    }

    Foo.prototype.second = function() {
        this.first(source("t2.1"));
    }
}

function t3() {
    function Foo() {}

    Foo.prototype = {};

    Foo.prototype.first = function(x) {
        sink(x); // $ hasValueFlow=t3.1
    }

    Foo.prototype.second = function() {
        this.first(source("t3.1"));
    }
}
