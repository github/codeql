import * as dummy from 'dummy';

function oneUse() {
    let taint = source();

    if (!isSafe(taint)) {
        return;
    }

    let array = [];
    if (taint) {
        array.push(taint);
    }

    sink(array.join()); // OK
}

function secondUse() {
    let taint = source();

    if (!isSafe(taint)) {
        return;
    }

    let array = [];
    if (taint) {
        array.push(taint);
    }
    if (taint) {
        array.push(taint);
    }

    sink(array.join()); // OK
}
