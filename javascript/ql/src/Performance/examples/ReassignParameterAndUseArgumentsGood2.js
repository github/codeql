function sum(xs, _start) {
    var start = arguments.length < 2 ? 0 : _start;

    var sum = start;
    for (var i=0; i<xs.length; ++i)
        sum += xs[i];

    return sum;
}
