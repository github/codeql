import * as dummy from 'dummy';

function foo(x, y) {
    sink(y);
}

let foo0 = foo.bind(null);
let foo1 = foo.bind(null, null);
let foo2 = foo.bind(null, null, null);

foo0(source(), null);   // OK
foo0(null, source());   // NOT OK

foo1(source());         // NOT OK
foo1(null, source());   // OK

foo2(source());         // OK
foo2(null, source());   // OK


function takesCallback(cb) {
    cb(source());       // NOT OK
}
function callback(x, y) {
    sink(y);
}
takesCallback(callback.bind(null, null));

function id(x) {
    return x;
}

let sourceGetter = id.bind(null, source());
let constGetter = id.bind(null, 'safe');

sink(sourceGetter()); // NOT OK - but not flagged
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
