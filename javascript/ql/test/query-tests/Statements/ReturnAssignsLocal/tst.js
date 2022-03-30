// NOT OK
function f(x) {
	return x = 23;
}

// NOT OK
function g() {
	var x;
	return x = 23;
}

// OK
function h() {
	return x = 23;
}

// OK
function k() {
	try {
		return x = 23;
	} catch(x) {}
}

// OK: the return statement assigns to a global, not the catch variable
function l() {
	try {
		throw new Error();
	} catch(x) {}
	return x = 23;
}

// OK
function m() {
	var x = 23;
	return function() {
		return x = x + 19;
	};
}

// OK
function n(x) {
	global_getter = function() {
		return x;
	};
	return x = 23;
}

// OK
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
