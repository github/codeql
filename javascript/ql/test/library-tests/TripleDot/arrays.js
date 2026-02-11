import 'dummy';

function shiftKnown() {
    let array = [source('shift.1'), source('shift.2')];
    sink(array.shift()); // $ hasValueFlow=shift.1
    sink(array.shift()); // $ SPURIOUS: hasValueFlow=shift.1 MISSING: hasValueFlow=shift.2
}

function shiftUnknown() {
    const array = new Array(Math.floor(Math.random() * 10));
    array.push(source('shift.unkn'));
    sink(array.shift()); // $ hasValueFlow=shift.unkn
    sink(array.shift()); // $ hasValueFlow=shift.unkn
    sink(array.shift()); // $ hasValueFlow=shift.unkn
}

function shiftTaint() {
    const array = source('shift.directly-tainted');
    sink(array.shift()); // $ hasTaintFlow=shift.directly-tainted
    sink(array.shift()); // $ hasTaintFlow=shift.directly-tainted
    sink(array.shift()); // $ hasTaintFlow=shift.directly-tainted
}

function implicitToString() {
    const array = [source('implicitToString.1')];
    array.push(source('implicitToString.2'))

    sink(array + "foo"); // $ hasTaintFlow=implicitToString.1 hasTaintFlow=implicitToString.2
    sink("foo" + array); // $ hasTaintFlow=implicitToString.1 hasTaintFlow=implicitToString.2
    sink("" + array); // $ hasTaintFlow=implicitToString.1 hasTaintFlow=implicitToString.2
    sink(array + 1); // $ hasTaintFlow=implicitToString.1 hasTaintFlow=implicitToString.2
    sink(1 + array); // $ hasTaintFlow=implicitToString.1 hasTaintFlow=implicitToString.2
    sink(unknown() + array); // $ hasTaintFlow=implicitToString.1 hasTaintFlow=implicitToString.2
    sink(array + unknown()); // $ hasTaintFlow=implicitToString.1 hasTaintFlow=implicitToString.2

    sink(`${array}`); // $ hasTaintFlow=implicitToString.1 hasTaintFlow=implicitToString.2
    sink(`${array} foo`); // $ hasTaintFlow=implicitToString.1 hasTaintFlow=implicitToString.2

    sink(String(array)); // $ hasTaintFlow=implicitToString.1 hasTaintFlow=implicitToString.2

    sink(array.toString()); // $ hasTaintFlow=implicitToString.1 hasTaintFlow=implicitToString.2
    sink(array.toString("utf8")); // $ hasTaintFlow=implicitToString.1 hasTaintFlow=implicitToString.2

    sink(Array.prototype.toString.call(array)); // $ hasTaintFlow=implicitToString.1 hasTaintFlow=implicitToString.2
    sink(Object.prototype.toString.call(array)); // OK - returns "[object Array]"
}
