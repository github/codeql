import * as dummy from 'dummy';

var source = "src1";
var shared;
a(source);
function a(x) {
    shared = x;
}
function b() {
    return shared + 'blah';
}
function c() {
    var sink = b(); // free to return out of b() because context is 'outer'
}
