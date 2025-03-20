import Express = require('express');

namespace A {
    export import E = Express;
}
namespace B {
    export import Q = A
}
namespace C {
    import E = Express;
    export const A = E;
}

function t1(x: A.E.Request) { // $ MISSING: hasUnderlyingType='express'.Request
}

function t2(x: B.Q.E.Request) { // $ MISSING: hasUnderlyingType='express'.Request
}

function t3(x: typeof Express) { // $ MISSING: hasUnderlyingType='express'
}

function t4(x: typeof A.E) { // $ MISSING: hasUnderlyingType='express'
}

function t5(x: typeof C.A) { // $ MISSING: hasUnderlyingType='express'
}
