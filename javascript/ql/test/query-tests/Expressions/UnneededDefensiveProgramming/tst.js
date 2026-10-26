(function(){
    var v;
    var u = undefined;
    var n = null;
    var o = {};
    var x = functionWithUnknownReturnValue();

    var u_ = u;
    var n_ = n;
    var o_ = o;
    var x_ = x;

    u_ = u_ || e; // $ MISSING: Alert[js/unneeded-defensive-code]
    n_ = n_ || e; // $ MISSING: Alert[js/unneeded-defensive-code]
    o_ = o_ || e; // $ MISSING: Alert[js/unneeded-defensive-code]
    x_ = x_ || e;

    u && u.p; // $ Alert[js/unneeded-defensive-code]
    n && n.p; // $ Alert[js/unneeded-defensive-code]
    o && o.p; // $ Alert[js/unneeded-defensive-code]
    x && x.p;

    u && u(); // $ Alert[js/unneeded-defensive-code]
    n && n(); // $ Alert[js/unneeded-defensive-code]
    o && o(); // $ Alert[js/unneeded-defensive-code]
    x && x();

    !u || u.p; // $ Alert[js/unneeded-defensive-code]
    !n || n.p; // $ Alert[js/unneeded-defensive-code]
    !o || o.p; // $ Alert[js/unneeded-defensive-code]
    !x || x.p;

    !!u && u.p; // $ Alert[js/unneeded-defensive-code]
    !!n && n.p; // $ Alert[js/unneeded-defensive-code]
    !!o && o.p; // $ Alert[js/unneeded-defensive-code]
    !!x && x.p;

    u != undefined && u.p; // $ Alert[js/unneeded-defensive-code]
    n != undefined && n.p; // $ Alert[js/unneeded-defensive-code]
    o != undefined && o.p; // $ Alert[js/unneeded-defensive-code]
    x != undefined && x.p;

    u == undefined || u.p; // $ Alert[js/unneeded-defensive-code]
    n == undefined || n.p; // $ Alert[js/unneeded-defensive-code]
    o == undefined || o.p; // $ Alert[js/unneeded-defensive-code]
    x == undefined || x.p;

    u === undefined || u.p; // $ Alert[js/unneeded-defensive-code]
    n === undefined || n.p; // $ Alert[js/unneeded-defensive-code]
    o === undefined || o.p; // $ Alert[js/unneeded-defensive-code]
    x === undefined || x.p;

    if (u) { // $ Alert[js/unneeded-defensive-code]
        u.p;
    }
    if (n) { // $ Alert[js/unneeded-defensive-code]
        n.p;
    }
    if (o) { // $ Alert[js/unneeded-defensive-code]
        o.p;
    }
    if (x) {
        x.p;
    }

    u? u():_; // $ Alert[js/unneeded-defensive-code]
    n? n(): _; // $ Alert[js/unneeded-defensive-code]
    o? o(): _; // $ Alert[js/unneeded-defensive-code]
    x? x(): _;

    if (u !== undefined) { // $ Alert[js/unneeded-defensive-code]
        u.p;
    }
    if (n !== undefined) { // $ Alert[js/unneeded-defensive-code]
        n.p;
    }
    if (o !== undefined) { // $ Alert[js/unneeded-defensive-code]
        o.p;
    }
    if (x !== undefined) {
        x.p;
    }

    if (u == undefined){} // $ Alert[js/unneeded-defensive-code]
    if (n == undefined){} // $ Alert[js/unneeded-defensive-code]
    if (o == undefined){} // $ Alert[js/unneeded-defensive-code]
    if (x == undefined){}

    if (u != undefined){} // $ Alert[js/unneeded-defensive-code]
    if (n != undefined){} // $ Alert[js/unneeded-defensive-code]
    if (o != undefined){} // $ Alert[js/unneeded-defensive-code]
    if (x != undefined){}

    if (typeof u === "undefined"){} // $ Alert[js/unneeded-defensive-code]
    if (typeof n === "undefined"){} // $ Alert[js/unneeded-defensive-code]
    if (typeof o === "undefined"){} // $ Alert[js/unneeded-defensive-code]
    if (typeof x === "undefined"){}

    function f() { }
    typeof f === "function" && f(); // $ Alert[js/unneeded-defensive-code]
    typeof u === "function" && u(); // $ Alert[js/unneeded-defensive-code]
    typeof x === "function" && x();

    var empty_array = [];
    var pseudo_empty_array = [''];
    var non_empty_array = ['foo'];
    var empty_string = "";
    var non_empty_string = "foo";
    var zero = 0;
    var neg = -1;
    var _true = true;
    var _false = false;

    empty_array && empty_array.pop(); // $ Alert[js/unneeded-defensive-code]
    pseudo_empty_array && pseudo_empty_array.pop(); // $ Alert[js/unneeded-defensive-code]
    non_empty_array && non_empty_array.pop(); // $ Alert[js/unneeded-defensive-code]
    empty_string && empty_string.charAt(0);
    non_empty_string && non_empty_string.charAt(0);
    zero && zero();
    neg && neg();
    _true && _true();
    _false && _false();

    (u !== undefined && u !== null) && u.p; // $ Alert[js/unneeded-defensive-code]
    u !== undefined && u !== null && u.p; // $ Alert[js/unneeded-defensive-code]

    u != undefined && u != null; // $ Alert[js/unneeded-defensive-code]
    u == undefined || u == null; // $ Alert[js/unneeded-defensive-code]
    u !== undefined && u !== null; // $ Alert[js/unneeded-defensive-code]
    !(u === undefined) && !(u === null); // $ Alert[js/unneeded-defensive-code]
    u === undefined || u === null; // $ Alert[js/unneeded-defensive-code]
    !(u === undefined || u === null); // $ Alert[js/unneeded-defensive-code]
    !(u === undefined) && u !== null; // $ Alert[js/unneeded-defensive-code]
    u !== undefined && n !== null;
    u == undefined && u == null; // $ Alert[js/unneeded-defensive-code]
    x == undefined && x == null;

    x === undefined && x === null; // $ Alert[js/unneeded-defensive-code]
    if (x === undefined) {
        if (x === null) { // $ Alert[js/unneeded-defensive-code]
        }
    }

    x !== undefined && x !== null;
    if (x !== undefined) {
        if (x !== null) {
        }
    }

    x == undefined && x == null;
    if (x == undefined) {
        if (x == null) {
        }
    }

    x != undefined && x != null; // $ Alert[js/unneeded-defensive-code]
    if (x != undefined) {
        if (x != null) { // $ Alert[js/unneeded-defensive-code]
        }
    }

    if (typeof x !== undefined); // $ Alert[js/comparison-between-incompatible-types]
    if (typeof window !== undefined); // $ Alert[js/comparison-between-incompatible-types]
    if (typeof x !== x);
    if (typeof x !== u); // $ Alert[js/comparison-between-incompatible-types]

    if (typeof window !== "undefined");
    if (typeof module !== "undefined");
    if (typeof global !== "undefined");

    if (typeof window !== "undefined" && window.document);
    if (typeof module !== "undefined" && module.exports);
    if (typeof global !== "undefined" && global.process);

	u && (f(), u.p); // $ Alert[js/trivial-conditional]
	u && (u.p, f()); // $ Alert[js/trivial-conditional] - technically not OK, but it seems like an unlikely pattern
	u && !u.p; // $ Alert[js/unneeded-defensive-code]
	u && !u(); // $ Alert[js/unneeded-defensive-code]


    function hasCallbacks(success, error) {
        if (success) success()
        if (error) error()
    }
    hasCallbacks(() => {}, null);
});
