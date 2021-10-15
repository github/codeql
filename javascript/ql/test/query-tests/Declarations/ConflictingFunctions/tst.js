function f(x) {
	if (x > 23) {
		function g() {
			return 42;
		}
	} else {
		function g() {
			return 56;
		}
	}
	return g();
}

function f2(x) {
	'use strict';
	if (x > 23) {
		function g() {
			return 42;
		}
	} else {
		function g() {
			return 56;
		}
	}
	return g();
}

function f3(x) {
	'use strict';
	function f4() {
		if (x > 23) {
			function g() {
				return 42;
			}
		} else {
			function g() {
				return 56;
			}
		}
		return g();
	}
}
