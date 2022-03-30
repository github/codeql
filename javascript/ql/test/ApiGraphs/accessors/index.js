const foo = require('foo');

foo({
    myMethod(x) { /* use (parameter 0 (member myMethod (parameter 0 (member exports (module foo))))) */
        console.log(x);
    }
});

foo({
    get myMethod() {
        return function(x) { /* use (parameter 0 (member myMethod (parameter 0 (member exports (module foo))))) */
            console.log(x)
        }
    }
});

class C {
    static myMethod(x) { /* use (parameter 0 (member myMethod (parameter 0 (member exports (module foo))))) */
        console.log(x);
    }
}
foo(C);

class D {
    myMethod(x) { /* use (parameter 0 (member myMethod (parameter 0 (member exports (module foo))))) */
        console.log(x);
    }
}
foo(new D());

class E {
    get myMethod() {
        return function(x) { /* use (parameter 0 (member myMethod (parameter 0 (member exports (module foo))))) */
            console.log(x);
        }
    }
}
foo(new E());

class F {
    static get myMethod() {
        return function(x) { /* use (parameter 0 (member myMethod (parameter 0 (member exports (module foo))))) */
            console.log(x);
        }
    }
}
foo(F);

// Cases where the class is instantiated in `foo`:

class G {
    myMethod2(x) { /* use (parameter 0 (member myMethod2 (instance (parameter 0 (member exports (module foo)))))) */
        console.log(x);
    }
}
foo(G);

class H {
    get myMethod2() {
        return function (x) { /* use (parameter 0 (member myMethod2 (instance (parameter 0 (member exports (module foo)))))) */
            console.log(x);
        }
    }
}
foo(H);
