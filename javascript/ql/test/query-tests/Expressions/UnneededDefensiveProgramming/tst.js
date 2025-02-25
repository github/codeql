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

    u_ = u_ || e; // $ MISSING: Alert
    n_ = n_ || e; // $ MISSING: Alert
    o_ = o_ || e; // $ MISSING: Alert
    x_ = x_ || e;

    u && u.p; // $ MISSING: Alert
    n && n.p; // $ MISSING: Alert
    o && o.p; // $ MISSING: Alert
    x && x.p;

    u && u(); // $ MISSING: Alert
    n && n(); // $ MISSING: Alert
    o && o(); // $ MISSING: Alert
    x && x();

    !u || u.p; // $ MISSING: Alert
    !n || n.p; // $ MISSING: Alert
    !o || o.p; // $ MISSING: Alert
    !x || x.p;

    !!u && u.p; // $ MISSING: Alert
    !!n && n.p; // $ MISSING: Alert
    !!o && o.p; // $ MISSING: Alert
    !!x && x.p;

    u != undefined && u.p; // $ MISSING: Alert
    n != undefined && n.p; // $ MISSING: Alert
    o != undefined && o.p; // $ MISSING: Alert
    x != undefined && x.p;

    u == undefined || u.p; // $ MISSING: Alert
    n == undefined || n.p; // $ MISSING: Alert
    o == undefined || o.p; // $ MISSING: Alert
    x == undefined || x.p;

    u === undefined || u.p; // $ MISSING: Alert
    n === undefined || n.p; // $ MISSING: Alert
    o === undefined || o.p; // $ MISSING: Alert
    x === undefined || x.p;

    if (u) { // $ MISSING: Alert
        u.p;
    }
    if (n) { // $ MISSING: Alert
        n.p;
    }
    if (o) { // $ MISSING: Alert
        o.p;
    }
    if (x) {
        x.p;
    }

    u? u():_; // $ MISSING: Alert
    n? n(): _; // $ MISSING: Alert
    o? o(): _; // $ MISSING: Alert
    x? x(): _;

    if (u !== undefined) { // $ MISSING: Alert
        u.p;
    }
    if (n !== undefined) { // $ MISSING: Alert
        n.p;
    }
    if (o !== undefined) { // $ MISSING: Alert
        o.p;
    }
    if (x !== undefined) {
        x.p;
    }

    if (u == undefined){} // $ MISSING: Alert
    if (n == undefined){} // $ MISSING: Alert
    if (o == undefined){} // $ MISSING: Alert
    if (x == undefined){}

    if (u != undefined){} // $ MISSING: Alert
    if (n != undefined){} // $ MISSING: Alert
    if (o != undefined){} // $ MISSING: Alert
    if (x != undefined){}

    if (typeof u === "undefined"){} // $ MISSING: Alert
    if (typeof n === "undefined"){} // $ MISSING: Alert
    if (typeof o === "undefined"){} // $ MISSING: Alert
    if (typeof x === "undefined"){}

    function f() { }
    typeof f === "function" && f(); // $ MISSING: Alert
    typeof u === "function" && u(); // $ MISSING: Alert
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

    empty_array && empty_array.pop(); // $ MISSING: Alert
    pseudo_empty_array && pseudo_empty_array.pop(); // $ MISSING: Alert
    non_empty_array && non_empty_array.pop(); // $ MISSING: Alert
    empty_string && empty_string.charAt(0);
    non_empty_string && non_empty_string.charAt(0);
    zero && zero();
    neg && neg();
    _true && _true();
    _false && _false();

    (u !== undefined && u !== null) && u.p; // $ MISSING: Alert
    u !== undefined && u !== null && u.p; // $ MISSING: Alert

    u != undefined && u != null; // $ MISSING: Alert
    u == undefined || u == null; // $ MISSING: Alert
    u !== undefined && u !== null; // $ MISSING: Alert
    !(u === undefined) && !(u === null); // $ MISSING: Alert
    u === undefined || u === null; // $ MISSING: Alert
    !(u === undefined || u === null); // $ MISSING: Alert
    !(u === undefined) && u !== null; // $ MISSING: Alert
    u !== undefined && n !== null;
    u == undefined && u == null; // $ MISSING: Alert
    x == undefined && x == null;

    x === undefined && x === null; // $ MISSING: Alert
    if (x === undefined) {
        if (x === null) { // $ MISSING: Alert
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

    x != undefined && x != null; // $ MISSING: Alert
    if (x != undefined) {
        if (x != null) { // $ MISSING: Alert
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
	u && !u.p; // $ MISSING: Alert
	u && !u(); // $ MISSING: Alert

    
    function hasCallbacks(success, error) {
        if (success) success()
        if (error) error()
    }
    hasCallbacks(() => {}, null);
});
