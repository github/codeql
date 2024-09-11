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
