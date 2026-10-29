(function (i) {
	if (i <= 1)
		return 1;
	return i*arguments.callee(i-1); // $ Alert
}(3));

function f() {
	g();
}

function g() {
	return arguments.caller.length; // $ Alert
}

function h(arguments) {
	return arguments.callee;
}