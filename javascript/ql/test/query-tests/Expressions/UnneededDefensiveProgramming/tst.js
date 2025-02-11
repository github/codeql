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

    u_ = u_ || e; // $ Alert TODO-MISSING: Alert[js/comparison-between-incompatible-types] Alert[js/trivial-conditional] Alert[js/unneeded-defensive-code]
    n_ = n_ || e; // $ Alert TODO-MISSING: Alert[js/comparison-between-incompatible-types] Alert[js/trivial-conditional] Alert[js/unneeded-defensive-code]
    o_ = o_ || e; // $ Alert TODO-MISSING: Alert[js/comparison-between-incompatible-types] Alert[js/trivial-conditional] Alert[js/unneeded-defensive-code]
    x_ = x_ || e;

    u && u.p; // $ Alert TODO-MISSING: Alert[js/comparison-between-incompatible-types] Alert[js/trivial-conditional]
    n && n.p; // $ Alert TODO-MISSING: Alert[js/comparison-between-incompatible-types] Alert[js/trivial-conditional]
    o && o.p; // $ Alert TODO-MISSING: Alert[js/comparison-between-incompatible-types] Alert[js/trivial-conditional]
    x && x.p;

    u && u(); // $ Alert TODO-MISSING: Alert[js/comparison-between-incompatible-types] Alert[js/trivial-conditional]
    n && n(); // $ Alert TODO-MISSING: Alert[js/comparison-between-incompatible-types] Alert[js/trivial-conditional]
    o && o(); // $ Alert TODO-MISSING: Alert[js/comparison-between-incompatible-types] Alert[js/trivial-conditional]
    x && x();

    !u || u.p; // $ Alert TODO-MISSING: Alert[js/comparison-between-incompatible-types] Alert[js/trivial-conditional]
    !n || n.p; // $ Alert TODO-MISSING: Alert[js/comparison-between-incompatible-types] Alert[js/trivial-conditional]
    !o || o.p; // $ Alert TODO-MISSING: Alert[js/comparison-between-incompatible-types] Alert[js/trivial-conditional]
    !x || x.p;

    !!u && u.p; // $ Alert TODO-MISSING: Alert[js/comparison-between-incompatible-types] Alert[js/trivial-conditional]
    !!n && n.p; // $ Alert TODO-MISSING: Alert[js/comparison-between-incompatible-types] Alert[js/trivial-conditional]
    !!o && o.p; // $ Alert TODO-MISSING: Alert[js/comparison-between-incompatible-types] Alert[js/trivial-conditional]
    !!x && x.p;

    u != undefined && u.p; // $ Alert TODO-MISSING: Alert[js/comparison-between-incompatible-types] Alert[js/trivial-conditional]
    n != undefined && n.p; // $ Alert TODO-MISSING: Alert[js/comparison-between-incompatible-types] Alert[js/trivial-conditional]
    o != undefined && o.p; // $ Alert TODO-MISSING: Alert[js/comparison-between-incompatible-types] Alert[js/trivial-conditional]
    x != undefined && x.p;

    u == undefined || u.p; // $ Alert TODO-MISSING: Alert[js/comparison-between-incompatible-types] Alert[js/trivial-conditional]
    n == undefined || n.p; // $ Alert TODO-MISSING: Alert[js/comparison-between-incompatible-types] Alert[js/trivial-conditional]
    o == undefined || o.p; // $ Alert TODO-MISSING: Alert[js/comparison-between-incompatible-types] Alert[js/trivial-conditional]
    x == undefined || x.p;

    u === undefined || u.p; // $ Alert TODO-MISSING: Alert[js/comparison-between-incompatible-types] Alert[js/trivial-conditional]
    n === undefined || n.p; // $ Alert TODO-MISSING: Alert[js/comparison-between-incompatible-types] Alert[js/trivial-conditional]
    o === undefined || o.p; // $ Alert TODO-MISSING: Alert[js/comparison-between-incompatible-types] Alert[js/trivial-conditional]
    x === undefined || x.p;

    if (u) { // $ Alert TODO-MISSING: Alert[js/comparison-between-incompatible-types] Alert[js/trivial-conditional]
        u.p;
    }
    if (n) { // $ Alert TODO-MISSING: Alert[js/comparison-between-incompatible-types] Alert[js/trivial-conditional]
        n.p;
    }
    if (o) { // $ Alert TODO-MISSING: Alert[js/comparison-between-incompatible-types] Alert[js/trivial-conditional]
        o.p;
    }
    if (x) {
        x.p;
    }

    u? u():_; // $ Alert TODO-MISSING: Alert[js/comparison-between-incompatible-types] Alert[js/trivial-conditional]
    n? n(): _; // $ Alert TODO-MISSING: Alert[js/comparison-between-incompatible-types] Alert[js/trivial-conditional]
    o? o(): _; // $ Alert TODO-MISSING: Alert[js/comparison-between-incompatible-types] Alert[js/trivial-conditional]
    x? x(): _;

    if (u !== undefined) { // $ Alert TODO-MISSING: Alert[js/comparison-between-incompatible-types] Alert[js/trivial-conditional]
        u.p;
    }
    if (n !== undefined) { // $ Alert TODO-MISSING: Alert[js/comparison-between-incompatible-types] Alert[js/trivial-conditional]
        n.p;
    }
    if (o !== undefined) { // $ Alert TODO-MISSING: Alert[js/comparison-between-incompatible-types] Alert[js/trivial-conditional]
        o.p;
    }
    if (x !== undefined) {
        x.p;
    }

    if (u == undefined){} // $ Alert TODO-MISSING: Alert[js/comparison-between-incompatible-types] Alert[js/trivial-conditional]
    if (n == undefined){} // $ Alert TODO-MISSING: Alert[js/comparison-between-incompatible-types] Alert[js/trivial-conditional]
    if (o == undefined){} // $ Alert TODO-MISSING: Alert[js/comparison-between-incompatible-types] Alert[js/trivial-conditional]
    if (x == undefined){}

    if (u != undefined){} // $ Alert TODO-MISSING: Alert[js/comparison-between-incompatible-types] Alert[js/trivial-conditional]
    if (n != undefined){} // $ Alert TODO-MISSING: Alert[js/comparison-between-incompatible-types] Alert[js/trivial-conditional]
    if (o != undefined){} // $ Alert TODO-MISSING: Alert[js/comparison-between-incompatible-types] Alert[js/trivial-conditional]
    if (x != undefined){}

    if (typeof u === "undefined"){} // $ Alert TODO-MISSING: Alert[js/comparison-between-incompatible-types] Alert[js/trivial-conditional]
    if (typeof n === "undefined"){} // $ Alert TODO-MISSING: Alert[js/comparison-between-incompatible-types] Alert[js/trivial-conditional]
    if (typeof o === "undefined"){} // $ Alert TODO-MISSING: Alert[js/comparison-between-incompatible-types] Alert[js/trivial-conditional]
    if (typeof x === "undefined"){}

    function f() { }
    typeof f === "function" && f(); // $ Alert TODO-MISSING: Alert[js/comparison-between-incompatible-types] Alert[js/trivial-conditional]
    typeof u === "function" && u(); // $ Alert TODO-MISSING: Alert[js/comparison-between-incompatible-types] Alert[js/trivial-conditional]
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

    empty_array && empty_array.pop(); // $ Alert TODO-MISSING: Alert[js/comparison-between-incompatible-types] Alert[js/trivial-conditional]
    pseudo_empty_array && pseudo_empty_array.pop(); // $ Alert TODO-MISSING: Alert[js/comparison-between-incompatible-types] Alert[js/trivial-conditional]
    non_empty_array && non_empty_array.pop(); // $ Alert TODO-MISSING: Alert[js/comparison-between-incompatible-types] Alert[js/trivial-conditional]
    empty_string && empty_string.charAt(0);
    non_empty_string && non_empty_string.charAt(0);
    zero && zero();
    neg && neg();
    _true && _true();
    _false && _false();

    (u !== undefined && u !== null) && u.p; // $ Alert TODO-MISSING: Alert[js/comparison-between-incompatible-types] Alert[js/trivial-conditional]
    u !== undefined && u !== null && u.p; // $ Alert TODO-MISSING: Alert[js/comparison-between-incompatible-types] Alert[js/trivial-conditional]

    u != undefined && u != null; // $ Alert TODO-MISSING: Alert[js/comparison-between-incompatible-types] Alert[js/trivial-conditional]
    u == undefined || u == null; // $ Alert TODO-MISSING: Alert[js/comparison-between-incompatible-types] Alert[js/trivial-conditional]
    u !== undefined && u !== null; // $ Alert TODO-MISSING: Alert[js/comparison-between-incompatible-types] Alert[js/trivial-conditional]
    !(u === undefined) && !(u === null); // $ Alert TODO-MISSING: Alert[js/comparison-between-incompatible-types] Alert[js/trivial-conditional]
    u === undefined || u === null; // $ Alert TODO-MISSING: Alert[js/comparison-between-incompatible-types] Alert[js/trivial-conditional]
    !(u === undefined || u === null); // $ Alert TODO-MISSING: Alert[js/comparison-between-incompatible-types] Alert[js/trivial-conditional]
    !(u === undefined) && u !== null; // $ Alert TODO-MISSING: Alert[js/comparison-between-incompatible-types] Alert[js/trivial-conditional]
    u !== undefined && n !== null;
    u == undefined && u == null; // $ Alert TODO-MISSING: Alert[js/comparison-between-incompatible-types] Alert[js/trivial-conditional]
    x == undefined && x == null;

    x === undefined && x === null; // $ Alert TODO-MISSING: Alert[js/comparison-between-incompatible-types] Alert[js/trivial-conditional]
    if (x === undefined) {
        if (x === null) { // $ Alert TODO-MISSING: Alert[js/comparison-between-incompatible-types] Alert[js/trivial-conditional]
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

    x != undefined && x != null; // $ Alert TODO-MISSING: Alert[js/comparison-between-incompatible-types] Alert[js/trivial-conditional]
    if (x != undefined) {
        if (x != null) { // $ Alert TODO-MISSING: Alert[js/comparison-between-incompatible-types] Alert[js/trivial-conditional]
        }
    }

    if (typeof x !== undefined); // $ TODO-SPURIOUS: Alert[js/comparison-between-incompatible-types]
    if (typeof window !== undefined); // $ TODO-SPURIOUS: Alert[js/comparison-between-incompatible-types]
    if (typeof x !== x);
    if (typeof x !== u); // $ Alert TODO-MISSING: Alert[js/trivial-conditional] Alert[js/unneeded-defensive-code]

    if (typeof window !== "undefined");
    if (typeof module !== "undefined");
    if (typeof global !== "undefined");

    if (typeof window !== "undefined" && window.document);
    if (typeof module !== "undefined" && module.exports);
    if (typeof global !== "undefined" && global.process);

	u && (f(), u.p); // $ TODO-SPURIOUS: Alert[js/trivial-conditional]
	u && (u.p, f()); // $ TODO-SPURIOUS: Alert[js/trivial-conditional] - technically not OK, but it seems like an unlikely pattern
	u && !u.p; // $ Alert TODO-MISSING: Alert[js/comparison-between-incompatible-types] Alert[js/trivial-conditional]
	u && !u(); // $ Alert TODO-MISSING: Alert[js/comparison-between-incompatible-types] Alert[js/trivial-conditional]

    
    function hasCallbacks(success, error) {
        if (success) success()
        if (error) error()
    }
    hasCallbacks(() => {}, null);
});
