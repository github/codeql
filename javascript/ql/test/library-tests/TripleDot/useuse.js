import 'dummy';

function t1() {
    const obj = {};

    sink(obj.field);

    obj.field = source('t1.1');
    sink(obj.field); // $ hasValueFlow=t1.1

    obj.field = "safe";
    sink(obj.field); // $ SPURIOUS: hasValueFlow=t1.1

    obj.field = source('t1.2');
    sink(obj.field); // $ hasValueFlow=t1.2 SPURIOUS: hasValueFlow=t1.1
}

function t2() {
    let obj;

    if (Math.random()) {
        obj = {};
        sink(obj.field);
    } else {
        obj = {};
        obj.field = source('t2.1');
        sink(obj.field); // $ hasValueFlow=t2.1
    }
    sink(obj.field); // $ hasValueFlow=t2.1
}
