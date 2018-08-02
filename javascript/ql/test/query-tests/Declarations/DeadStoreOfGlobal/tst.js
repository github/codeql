// NOT OK
g = 23;

// OK
h = 23;
alert(h);

// OK
uid = 0;
function incr() {
	return uid++;
}

// OK
function foo() {
	var x;
	x = 0;
}

// OK
onload = function() {}

// OK
global = 42;

// OK
prop = 42;

// OK
/*global otherGlobal*/
otherGlobal = 56;