function f() {}
var g = function() {}
h = function() {}
k = g

f();
g();
h();
k();

function l(m) {
	var n = m || function() {};
	function p() {}
	m();
	l();
	arguments.callee();
	n();
	p();
	f();
}

l(k);

new f();
new g;

(function(){})();
(function(){}());

var q;
var o = q = {
		f: function() {
			this.g();
		},
		g: function() {}
	},
	p = {
		f: function() {},
		g: g
	};
o.f();
(function(x) { return x; }(o)).f();

function A() {}
A.prototype.f = function() {
	this.g();
};
A.prototype.g = function() {};

function B() {}
B.prototype = {
	f: function() {
		this.g();
	}
};
B.prototype.g = Math.random() > 0.5 ? function() {}
                                    : function() {};

function C() {}
C.prototype = new A();
C.prototype.g = function() {};

(function() {
    var b = new B();
    b.f = function() {};
    b.f();
});

globalfn();
globalfn2();
