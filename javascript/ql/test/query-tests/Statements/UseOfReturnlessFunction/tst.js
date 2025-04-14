(function () {
    function stub() {
        throw new Error("Not implemented!");
    }

    function returnsValue() {
        var x = 3;
        return x * 2;
    }

    function onlySideEffects() {
        console.log("Boo!")
    }
    
    var arrow = () => onlySideEffects();

    console.log(returnsValue())
    console.log(stub())

    console.log(onlySideEffects()); // $ Alert

    var a = Math.random() > 0.5 ? returnsValue() : onlySideEffects(); // OK - A is never used.
    
    var b = onlySideEffects(); // $ Alert
    console.log(b);

	var c = 42 + (onlySideEffects(), 42); // OK - value is thrown away.
	console.log(c);
	
	var d = 42 + (42, onlySideEffects()); // $ Alert
	console.log(d);
	
	if (onlySideEffects()) { 
		// nothing.
	}
	
	for (i = 0; onlySideEffects(); i++) {
		// nothing. 
	}
	
	var myObj = {
		onlySideEffects: onlySideEffects
	}
	
	var e = myObj.onlySideEffects.apply(this, arguments); // $ MISSING: Alert
	console.log(e);
	
	function onlySideEffects2() {
        console.log("Boo!")
    }

	var bothOnlyHaveSideEffects = Math.random() > 0.5 ? onlySideEffects : onlySideEffects2;
	var f = bothOnlyHaveSideEffects(); // $ Alert
	console.log(f);
	
	var oneOfEach = Math.random() > 0.5 ? onlySideEffects : returnsValue;
	var g = oneOfEach();
	console.log(g);
	
	function alwaysThrows() {
		if (Math.random() > 0.5) {
			console.log("Whatever!")
		} else {
			console.log("Boo!")
		}
		throw new Error("Important error!")
	} 
	
	var h = returnsValue() || alwaysThrows();
	console.log(h);
	
	function equals(x, y) {
		return x === y;
	}
	
	var foo = [1,2,3].filter(n => {equals(n, 3)}) // $ Alert
	console.log(foo);
	
	import { filter } from 'lodash'
	var bar = filter([1,2,4], x => { equals(x, 3) } ) // $ Alert
	console.log(bar);
	
	var baz = [1,2,3].filter(n => {n === 3})
	console.log(baz);
	
	class Deferred {
	
	}
	
	new Deferred().resolve(onlySideEffects());
	
	Promise.all([onlySideEffects(), onlySideEffects()])
})();

+function() {
    console.log("FOO");
}.call(this);

class Foo {
	constructor() {
		console.log("FOO");
	}
}

class Bar extends Foo {
	constructor() {
		console.log(super());
	}
}

() => {
	let equals = (x, y) => { return x === y; };

	var foo = [1,2,3].findLastIndex(n => { equals(n, 3); }) // $ Alert
	console.log(foo);

	var foo = [1,2,3].findLast(n => { equals(n, 3); }) // $ Alert
	console.log(foo);
}
