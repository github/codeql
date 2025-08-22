function f1() {
    function inner(x) {
        return (function(p) {
            return p; // argument to return
        })(x);
    }
    sink(inner(source("f1.1"))); // $ hasValueFlow=f1.1
    sink(inner(source("f1.2"))); // $ hasValueFlow=f1.2
}

function f2() {
    function inner(x) {
        let y;
        (function(p) {
            y = p; // parameter to captured variable
        })(x);
        return y;
    }
    sink(inner(source("f2.1"))); // $ hasValueFlow=f2.1
    sink(inner(source("f2.2"))); // $ hasValueFlow=f2.2
}

function f3() {
    function inner(x) {
        return (function() {
            return x; // captured variable to return
        })();
    }
    sink(inner(source("f3.1"))); // $ hasValueFlow=f3.1
    sink(inner(source("f3.2"))); // $ hasValueFlow=f3.2
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

function f5() {
    function inner(x) {
        let y;
        function nested(p) {
            y = p;
        }
        nested(x);
        return y;
    }
    sink(inner(source("f5.1"))); // $ hasValueFlow=f5.1
    sink(inner(source("f5.2"))); // $ hasValueFlow=f5.2
}

function f6() {
    function inner(x) {
        let y;
        function nested(p) {
            y = p;
        }
        (nested)(x); // same as f5, except the callee is parenthesised here
        return y;
    }
    sink(inner(source("f6.1"))); // $ hasValueFlow=f6.1
    sink(inner(source("f6.2"))); // $ hasValueFlow=f6.2
}

function f7() {
    function inner(x) {
        let y;
        let nested = (function (p) {
            y = p;
        });
        nested(x); // same as f5, except the function definition is parenthesised
        return y;
    }
    sink(inner(source("f7.1"))); // $ hasValueFlow=f7.1
    sink(inner(source("f7.2"))); // $ hasValueFlow=f7.2
}
