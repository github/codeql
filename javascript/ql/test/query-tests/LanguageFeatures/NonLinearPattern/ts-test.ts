function distanceFromOrigin(point) {
    var [x, x] = point; // $ Alert
    return Math.sqrt(x*x + y*y);
}

var { x: x, y: x } = o; // $ Alert

var { x, x } = o; // $ Alert


var { x: x, x: y } = o;


var { p = x, q = x } = o;

function f({
    x: string,
    y: string  // $ Alert
}) {
}

function g({x, y}: {x: string, y: string}) {
}

function blah(arg) {
    var {
        x: x,
        y: {
            x: x, // $ Alert
            y: {
                x: x // $ Alert
            }
        }
    } = arg;
}

function h({x: string, y: string}: any) {  // $ Alert
}
