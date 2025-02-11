(function (i) {
	if (i <= 1)
		return 1;
	return i*arguments.callee(i-1); // $ TODO-SPURIOUS: Alert
}(3));

function f() {
	g();
}

function g() {
	return arguments.caller.length; // $ TODO-SPURIOUS: Alert
}

function h(arguments) {
	return arguments.callee;
}