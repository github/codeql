function f() {
	var x = g();
	return x+19;
}

function g() {
	return 23;
}

f(g()); // $ Alert

function sum() {
	var result = 0;
	for (var i=0,n=arguments.length; i<n; ++i)
		result += arguments[i];
	return result;
}


sum(1, 2, 3);

function h(k) {
	k = k || function() {};
	
	k(42);
}


new Array(1, 2, 3);

new String(1, 2, 3); // $ Alert

(function(f) {
	f(42); // $ Alert
})(function() {return;});

(function h(f) {
	
	f(42);
	h(function(x) { return x; });
})(function() {});

parseFloat("123", 10); // $ Alert - unlike parseInt this does not take a radix

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
	nonEmpty(42); // $ Alert
	empty(42);
	emptyWithParam(42, 87);	
	commentedEmpty(42);
	commentedEmptyWithSpreadParam(42, 87);
	emptyArrow(42); // $ Alert
	new ImplicitEmptyConstructor(42); // $ Alert
	new ExplicitEmptyConstructor(42); // $ Alert
	parseFloat("123", 10); // $ Alert
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
	notAPlainThrower1(42); // $ Alert
	notAPlainThrower2(42); // $ Alert
	notAPlainThrower3(42); // $ Alert
	thrower(42);
	throwerArrow(42);
	throwerCustom(42);
	throwerWithParam(42, 87); // $ Alert
	throwerIndirect(42); // $ SPURIOUS: Alert - flagged due to complexity
});

function sum2() {
	var result = 0;
	for (var i=0,n=sum2.arguments.length; i<n; ++i)
		result += sum2.arguments[i];
	return result;
}


sum2(1, 2, 3);

const $ = function (x, arr) {
  console.log(x, arr);
};


async function tagThing(repoUrl, directory) {
  await $`git clone ${repoUrl} ${directory}`;
}
