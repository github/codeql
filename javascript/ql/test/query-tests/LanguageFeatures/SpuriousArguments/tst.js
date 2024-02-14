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
});

(function testWhitelistThrowingFunctions() {
	function notAPlainThrower1(){
		if(DEBUG) {
			throw new Error("Remove this statement and implement this function");
		}
	};
	function notAPlainThrower2(){
		f();
		throw new Error("Internal error: should have thrown an exception before this.");
	};
	function notAPlainThrower3(){
		return;
		throw new Error("Internal error: should have returned before this.");
	};
	function thrower(){
		throw new Error("Remove this statement and implement this function");
	};
	const throwerArrow = () => { throw new Error("Remove this statement and implement this function"); };
	function throwerCustom(){
		throw new MyError("Remove this statement and implement this function");
	};
	function throwerWithParam(p){
		throw new Error(p);
	};
	function throwerIndirect(){
		(function(){
			{
				{
					throw Error("Remove this statement and implement this function");
				}
			}
		})();
	}
	notAPlainThrower1(42); // NOT OK
	notAPlainThrower2(42); // NOT OK
	notAPlainThrower3(42); // NOT OK
	thrower(42); // OK
	throwerArrow(42); // OK
	throwerCustom(42); // OK
	throwerWithParam(42, 87); // NOT OK
	throwerIndirect(42); // OK, but still flagged due to complexity
});

function sum2() {
	var result = 0;
	for (var i=0,n=sum2.arguments.length; i<n; ++i)
		result += sum2.arguments[i];
	return result;
}

// OK
sum2(1, 2, 3);

const $ = function (x, arr) {
  console.log(x, arr);
};

// OK
async function tagThing(repoUrl, directory) {
  await $`git clone ${repoUrl} ${directory}`;
}
