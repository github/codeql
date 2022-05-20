function sum(xs, start) {
    if (typeof start === 'undefined')
        start = 0;

    var sum = start;
    for (var i=0; i<xs.length; ++i)
        sum += xs[i];

    return sum;
}
