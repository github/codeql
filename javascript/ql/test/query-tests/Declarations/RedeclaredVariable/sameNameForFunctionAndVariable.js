var fun1;
function fun1() { // $ TODO-SPURIOUS: Alert
}

function fun2() {
}
var fun2; // $ TODO-SPURIOUS: Alert

var fun3;
var fun = function fun3() {
}
