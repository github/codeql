function sum(xs, start) { // $ Alert
    if (arguments.length < 2)
        start = 0;

    var sum = start;
    for (var i=0; i<xs.length; ++i)
        sum += xs[i];

    return sum;
}


function sum(xs, start) {
    if (typeof start === 'undefined')
        start = 0;

    var sum = start;
    for (var i=0; i<xs.length; ++i)
        sum += xs[i];

    return sum;
}


function sum(xs, _start) {
    var start = arguments.length < 2 ? _start : 0;

    var sum = start;
    for (var i=0; i<xs.length; ++i)
        sum += xs[i];

    return sum;
}
