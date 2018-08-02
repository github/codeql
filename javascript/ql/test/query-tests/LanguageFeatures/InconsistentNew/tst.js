function Point(x, y) {
	this.x = x;
	this.y = y;
}

new Point(23, 42);
Point(56, 72);

function RobustPoint(x, y) {
	if (!(this instanceof RobustPoint))
		return new RobustPoint(x, y);
	this.x = x;
	this.y = y;
}

new RobustPoint(23, 42);
RobustPoint(56, 72);

function RobustPoint2(x, y) {
	if (this.constructor !== RobustPoint2)
		return new RobustPoint2(x, y);
	this.x = x;
	this.y = y;
}

new RobustPoint2(23, 42);
RobustPoint2(56, 72);

function RobustPoint3(x, y) {
	var self = this;
	if (self.constructor !== arguments.callee)
		return new RobustPoint3(x, y);
	this.x = x;
	this.y = y;
}

new RobustPoint3(23, 42);
RobustPoint3(56, 72);


function RobustPoint4(x, y) {
	if (this.constructor !== arguments.callee)
		return new arguments.callee(x, y);
	this.x = x;
	this.y = y;
}

new RobustPoint4(23, 42);
RobustPoint4(56, 72);

// OK: Error is an external function
new Error();
Error();

class C {}
new C();
C(); // NOT OK, but flagged by IllegalInvocation

(function() {
	function A(x) {
		this.x = x;
	}
	new A(42);
	A.call({}, 23);
})();
