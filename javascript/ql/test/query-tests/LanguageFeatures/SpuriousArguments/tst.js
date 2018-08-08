function f() {
	var x = g();
	return x+19;
}

function g() {
	return 23;
}

// NOT OK
f(g());

function sum() {
	var result = 0;
	for (var i=0,n=arguments.length; i<n; ++i)
		result += arguments[i];
	return result;
}

// OK
sum(1, 2, 3);

function h(k) {
	k = k || function() {};
	// OK
	k(42);
}

// OK
new Array(1, 2, 3);

// NOT OK
new String(1, 2, 3);

(function(f) {
	// NOT OK
	f(42);
})(function() {return;});

(function h(f) {
	// OK
	f(42);
	h(function(x) { return x; });
})(function() {});

parseFloat("123", 10);

(function testWhitelistEmptyFunctions(){
	function nonEmpty(){
		return;
	}
	function empty(){

	}
	function emptyWithParam(p){
	}
	function commentedEmpty(){
		// doStuff(arguments);
	}
	function commentedEmptyWithSpreadParam(...args){
		// doStuff(args)
	}
	var emptyArrow = () => undefined;
	class ImplicitEmptyConstructor {
	}
	class ExplicitEmptyConstructor {
		constructor(){
		}
	}
	nonEmpty(42); // NOT OK
	empty(42); // OK
	emptyWithParam(42, 87);	// OK
	commentedEmpty(42); // OK
	commentedEmptyWithSpreadParam(42, 87); // OK
	emptyArrow(42); // NOT OK
	new ImplicitEmptyConstructor(42); // NOT OK
	new ExplicitEmptyConstructor(42); // NOT OK
	parseFloat("123", 10); // NOT OK
})
