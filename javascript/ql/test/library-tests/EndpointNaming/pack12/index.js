function wrap(fn) {
    return x => fn(x);
}

function f() {}
export const f1 = wrap(f); // $ name=(pack12).f1
export const f2 = wrap(f); // $ name=(pack12).f2

function g() {}
export const g1 = wrap(g); // $ name=(pack12).g1
