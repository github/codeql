function f(x) { // $ TODO-MISSING: Alert
	return x = 23; // $ TODO-SPURIOUS: Alert
}

function g() { // $ TODO-MISSING: Alert
	var x;
	return x = 23; // $ TODO-SPURIOUS: Alert
}


function h() {
	return x = 23;
}


function k() {
	try {
		return x = 23;
	} catch(x) {}
}

// OK - the return statement assigns to a global, not the catch variable
function l() {
	try {
		throw new Error();
	} catch(x) {}
	return x = 23;
}


function m() {
	var x = 23;
	return function() {
		return x = x + 19;
	};
}


function n(x) {
	global_getter = function() {
		return x;
	};
	return x = 23;
}


function p() {
	var x;
	return {
		g: function g() {
			return function h() {
				return x = 42;
			}
		},
		h: function() {
			return x;
		}
	};
}
