// NOT OK
function f() {
	if (foo())
		return true;
}

// OK
function g() {
	if (foo())
		return true;
	return false;
}

// OK
function h() {
	open();
	try {
		return bar();
	} finally {
		close();
	}
}

// OK
function k(x) {
	switch (x) {
	case 1:
		return 23;
	case 2:
		return;
	}
}

// OK
function l() {
	return 23;
	alert("Hi");
}

// OK
function m() {
	if (foo())
		return true;
	throw new Error("not foo!");
}

// OK
function n() {
	if (foo())
		return true;
	throwError("not foo!");	
}

function throwError(msg) {
	throw new Error(msg);
}

function foo() {
	return true;
}

// 
// OK: dual-use constructor
function Point(x, y) {
	if (!(this instanceof Point))
		return new Point(x, y);
	this.x = x;
	this.y = y;
}

// OK: infinite loops
function q(n) {
	for (var i=0;;++i)
		if (i>2*n)
			return i;
}

function r(n) {
	while (true) {
		if (n-->0)
			return 23;
	}
}

function s(n) {
	do {
		if (n++>56)
			return n-2;
	} while(1);
}

function t(n) {
	do {
		if (n++>56)
			return n-2;
	} while("true");
}

// NOT OK
var u = function() {
	if (foo())
		return true;
};

// NOT OK
function v(b) {
	if (b)
		return 1;
}
