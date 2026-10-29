import * as dummy from 'dummy';

function foo(x, y) {
    sink(y.test1); // OK
    sink(y.test2); // NOT OK
    sink(y.test3); // NOT OK
    sink(y.test4); // OK
    sink(y.test5); // OK
    sink(y.test6); // OK
}

let foo0 = foo.bind(null);
let foo1 = foo.bind(null, null);
let foo2 = foo.bind(null, null, null);

foo0({ test1: source() }, null);
foo0(null, { test2: source() });

foo1({ test3: source() });
foo1(null, { test4: source() });

foo2({ test5: source() });
foo2(null, { test6: source() });


function takesCallback(cb) {
    cb(source());
}
function callback(x, y) {
    sink(y); // NOT OK [INCONSISTENCY] - lambda flow in dataflow2 does not handle partial invocations yet
}
takesCallback(callback.bind(null, null));

function id(x) {
    return x;
}

let sourceGetter = id.bind(null, source());
let constGetter = id.bind(null, 'safe');

sink(sourceGetter()); // NOT OK [INCONSISTENCY]
sink(constGetter());   // OK

function id2(x, y) {
    return y;
}

let id3 = id2.bind(null, null);

sink(id3(source()));    // NOT OK
sink(id3('safe'));      // OK

function getSource() {
    return source();
}
let source0 = getSource.bind(null);
let source1 = getSource.bind(null, null);

sink(source0()); // NOT OK
sink(source1()); // NOT OK
