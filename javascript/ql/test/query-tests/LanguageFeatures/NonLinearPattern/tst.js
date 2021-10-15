function distanceFromOrigin(point) {
    // NOT OK
    var [x, x] = point;
    return Math.sqrt(x*x + y*y);
}

// NOT OK
var { x: x, y: x } = o;

// NOT OK
var { x, x } = o;

// OK
var { x: x, x: y } = o;

// OK
var { p = x, q = x } = o;
