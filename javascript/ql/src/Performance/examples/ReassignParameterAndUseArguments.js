function sum(xs, start) {
    if (arguments.length < 2)
        start = 0;

    var sum = start;
    for (var i=0; i<xs.length; ++i)
        sum += xs[i];

    return sum;
}
