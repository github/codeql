function f() {
	var g = function() {
		try {
			f();
		} catch (e) {
			;
		}
	};
}