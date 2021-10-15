function f() {
	if (arguments.length == 0)
		return 23;
	if (arguments.length % 2 != 0)
		return 42;
	console.log(arguments[0]);
	arguments[0]--;
	arguments[1] += 19;
	return arguments[0] * arguments[1];
}

function g() {
	if (arguments.length == 0)
		return 23;
	if (arguments.length % 2 != 0)
		return 42;
	console.log(arguments[0]);
	arguments[0]--;
	arguments[1] += 19;
	return arguments[0] * arguments[1];
}

var g2 = function() {
	if (arguments.length == 0)
		return 23;
	if (arguments.length % 2 != 0)
		return 42;
	console.log(arguments[0]);
	arguments[0]--;
	arguments[1] += 19;
	return arguments[0] * arguments[1];
}

// OK: only five statements
function h() {
	if (arguments.length == 0)
		return 23;
	if (arguments.length % 2 != 0)
		return 42;
	console.log(arguments[0]);
	arguments[0]--;
	arguments[1] += 19;	
}

function k() {
	if (arguments.length == 0)
		return 23;
	if (arguments.length % 2 != 0)
		return 42;
	console.log(arguments[0]);
	arguments[0]--;
	arguments[1] += 19;	
}
