function f(o) {
	with (o) {
		x = 42;
		return function () {
			x = 56;
		};
	}
}

var q = { x: 23 };
var h = f(q);
alert(q.x); // 42
h();
alert(q.x); // 56