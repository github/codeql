function getLastLine(input) {
  var lines = [], nextLine;
  while ((nextLine = readNextLine(input)))
    lines.push(nextLine);
  if (!lines.length)
    throw new Error("No lines!");
  return lines[lines.length-1];
}

(function tooSpecificFunctions(){
    function f1() {
        return false
    }
    if(f1()){} // OK, whitelisted

    function f2() {
        return false
    }
    if(!f2()){} // OK, whitelisted

    function f3() {
        return false
    }
    if(!!f3()){} // OK, whitelisted

    function f4() {
        return false
    }
    if(f4() || o.p){} // OK, whitelisted

    function f5() {
        return false
    }
    var v5 = f5();
    if(v5){} // OK, whitelisted

    function f6() {
        return false
    }
    var v6 = f6();
    if(!!v6){} // OK, whitelisted
})();

(function tooGeneralFunctions(){
    function f1(x) {
        if(x){} // OK, whitelisted
    }
    f1(undefined);
    f1({});

    function f2(x) {
        if(x){} // OK, whitelisted
    }
    f2(undefined);

    function f3(x1) {
        var x2 = x1;
        if(x2){} // NOT OK, not whitelisted
    }
    f3(undefined);

    function f4(x) {
        if(x && o.p){} // OK, whitelisted
    }
    f4(undefined);

    function f5(x, y) {
        var xy = o.q? x: y;
        if(xy && o.p){} // NOT OK, not whitelisted
    }
    f5(undefined, undefined);

    function f6(x) {
        if(!x){} // OK, whitelisted
    }
    f6(true);

    function f7(x) {
        if(!!x){} // OK, whitelisted
    }
    f7(true);

    function f8(x, y) {
        var xy = x || y;
        if(xy){} // NOT OK, not whitelisted
    }
    f8(undefined, undefined);

    function f9(x, y) {
        var xy = !x || y;
        if(xy){} // OK, whitelisted
    }
    f9(undefined, undefined);

    function f10(x, y) {
        var xy = !!x || y;
        if(xy){} // NOT OK, not whitelisted
    }
    f10(undefined, undefined);

})();

(function(){
	function g(p) {
		return function() {
			if (p) { // OK, whitelisted
				g(p);
			}
		};
	}

	function f(p = false) {
		return function() {
			if (p) { // OK, whitelisted
				f(p);
			}
		};
	}

	function h(p = false) {
		(function() {
			if (p) { // OK, whitelisted

			}
		});
	}
	h();
});
