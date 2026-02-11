function t1() {
    const arr = [1, 2, 3];
    const newArr = arr.with(1, source('with.1'));
    sink(newArr[1]); // $ hasValueFlow=with.1
}

function t2() {
    const arr = [source('with.2.1'), 2, source('with.2.3')];
    const newArr = arr.with(1, 'replaced');
    sink(newArr[0]); // $ hasValueFlow=with.2.1
    sink(newArr[2]); // $ hasValueFlow=with.2.3
}

function t3() {
    const arr = [1, 2, 3];
    const index = source('with.3.index');
    const newArr = arr.with(index, 'new value');
    // No assertions here as the index is tainted, not the value
}

function t4() {
    const arr = [1, 2, 3];
    const newArr = arr.with(1, source('with.4'));
    sink(arr[1]); // This should NOT have value flow as with() returns a new array
}
