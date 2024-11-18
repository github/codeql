function f1() {
    function inner(x) {
        return (function(p) {
            return p; // argument to return
        })(x);
    }
    sink(inner(source("f1.1"))); // $ hasValueFlow=f1.1 SPURIOUS: hasValueFlow=f1.2
    sink(inner(source("f1.2"))); // $ hasValueFlow=f1.2 SPURIOUS: hasValueFlow=f1.1
}

function f2() {
    function inner(x) {
        let y;
        (function(p) {
            y = p; // parameter to captured variable
        })(x);
        return y;
    }
    sink(inner(source("f2.1"))); // $ hasValueFlow=f2.1 SPURIOUS: hasValueFlow=f2.2
    sink(inner(source("f2.2"))); // $ hasValueFlow=f2.2 SPURIOUS: hasValueFlow=f2.1
}

function f3() {
    function inner(x) {
        return (function() {
            return x; // captured variable to return
        })();
    }
    sink(inner(source("f3.1"))); // $ hasValueFlow=f3.1 SPURIOUS: hasValueFlow=f3.2
    sink(inner(source("f3.2"))); // $ hasValueFlow=f3.2 SPURIOUS: hasValueFlow=f3.1
}

function f4() {
    function inner(x) {
        let y;
        (function() {
            y = x; // captured variable to captured variable
        })();
        return y;
    }
    sink(inner(source("f4.1"))); // $ hasValueFlow=f4.1
    sink(inner(source("f4.2"))); // $ hasValueFlow=f4.2
}
