function getLastLine(input) {
  var lines = [], nextLine;
  while ((nextLine = readNextLine(input)))
    lines.push(nextLine);
  if (!lines) // $ Alert
    throw new Error("No lines!");
  return lines[lines.length-1];
}

function lookup(cache, k) {
  var v;
  return k in cache ? cache[k] : (v = new Entry(recompute())) && (cache[k] = v); // $ Alert
}

function test(a, b) {
  if (!a && !b) {
    if (a); // $ Alert
    if (b); // $ Alert
  }
  if (!(a || b)) {
    if (a); // $ Alert
    if (b); // $ Alert
  }

  var x = new X();
  if(x){} // $ Alert
  if (new X()){} // $ Alert
  if((x)){} // $ Alert
  if(((x))){} // $ Alert
  if ((new X())){} // $ Alert

  x = 0n;
  if (x) // $ Alert
    ;
}

async function awaitFlow(){
    var v;

    if (y)
        v = await f()

    if (v) {
    }
}

(function(){
    function knownF() {
        return false;
    }
    var known = knownF();
    if (known)
        return;
    if (known) // $ Alert
        return;

    var unknown = unknownF();
    if (unknown)
        return;
    if (unknown) // $ Alert
        return;
});

(function (...x) {
    x || y // $ Alert
});

(function() {
    function f1(x) {
        x || y // OK
    }
    f1(true);

    function f2(x) {
        while (true)
            x || y // $ Alert
    }
    f2(true);

    function f3(x) {
        (function(){
            x || y // OK
        });
    }
    f3(true);
});

(function() {
    if ((x, true)); // $ Alert
});

(function (x, y) {
    if (!x) {
        while (x) { // $ Alert
            f();
        }
        while (true) {
            break;
        }
        if (true && true) {} // $ Alert
        if (y && x) {} // $ Alert
        if (y && (x)) {} // $ Alert
        do { } while (x); // $ Alert
    }
});

(function(x,y) {
    let obj = (x && {}) || y;
    if ((x && {}) || y) {} // $ Alert
});

(function(){
    function constantFalse1() {
        return false;
    }
    if (constantFalse1())
        return;

	function constantFalse2() {
		return false;
    }
	let constantFalse = unknown? constantFalse1 : constantFalse2;
    if (constantFalse2())
        return;

	function constantUndefined() {
        return undefined;
    }
	if (constantUndefined()) // $ Alert
        return;

	function constantFalseOrUndefined1() {
		return unknown? false: undefined;
	}
	if (constantFalseOrUndefined1()) // $ Alert
        return;

	let constantFalseOrUndefined2 = unknown? constantFalse1 : constantUndefined;
	if (constantFalseOrUndefined2())  // $ Alert
        return;

});

(function () {
	function p() {
		return {};
	}
	if (p()) { // $ Alert
	}
	var v = p();
	if (v) { // $ Alert
	}
	if (v) { // $ MISSING: Alert - due to SSA limitations
	}
});

(function() {
	function findOrThrow() {
		var e = find();
		if (e) return e;
		throw new Error();
	}
	if(findOrThrow()){ // $ Alert
	}
	var v = findOrThrow();
	if (v) { // $ Alert
	}
	if (v) { // $ MISSING: Alert - due to SSA limitations
	}
});

(function () {
	function f(){ return { v: unkown };}
	f();
	var { v } = f();
	if (v) {
	}
});

(function() {
    function outer(x) {
        addEventListener("click", () => {
            if (!x && something()) { // OK
                something();
            }
        });
    }
    function inner() {
        outer(); // Omit parameter
    }
    inner();
});
