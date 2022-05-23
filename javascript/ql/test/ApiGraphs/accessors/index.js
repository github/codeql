const foo = require('foo');

foo({
    myMethod(x) { /* use=moduleImport("foo").getMember("exports").getParameter(0).getMember("myMethod").getParameter(0) */
        console.log(x);
    }
});

foo({
    get myMethod() {
        return function (x) { /* use=moduleImport("foo").getMember("exports").getParameter(0).getMember("myMethod").getParameter(0) */
            console.log(x)
        }
    }
});

class C {
    static myMethod(x) { /* use=moduleImport("foo").getMember("exports").getParameter(0).getMember("myMethod").getParameter(0) */
        console.log(x);
    }
}
foo(C);

class D {
    myMethod(x) { /* use=moduleImport("foo").getMember("exports").getParameter(0).getMember("myMethod").getParameter(0) */
        console.log(x);
    }
}
foo(new D());

class E {
    get myMethod() {
        return function (x) { /* use=moduleImport("foo").getMember("exports").getParameter(0).getMember("myMethod").getParameter(0) */
            console.log(x);
        }
    }
}
foo(new E());

class F {
    static get myMethod() {
        return function (x) { /* use=moduleImport("foo").getMember("exports").getParameter(0).getMember("myMethod").getParameter(0) */
            console.log(x);
        }
    }
}
foo(F);

// Cases where the class is instantiated in `foo`:

class G {
    myMethod2(x) { /* use=moduleImport("foo").getMember("exports").getParameter(0).getInstance().getMember("myMethod2").getParameter(0) */
        console.log(x);
    }
}
foo(G);

class H {
    get myMethod2() {
        return function (x) { /* use=moduleImport("foo").getMember("exports").getParameter(0).getInstance().getMember("myMethod2").getParameter(0) */
            console.log(x);
        }
    }
}
foo(H);
