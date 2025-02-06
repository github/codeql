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

    u_ = u_ || e; // $ Alert
    n_ = n_ || e; // $ Alert
    o_ = o_ || e; // $ Alert
    x_ = x_ || e;

    u && u.p; // $ Alert
    n && n.p; // $ Alert
    o && o.p; // $ Alert
    x && x.p;

    u && u(); // $ Alert
    n && n(); // $ Alert
    o && o(); // $ Alert
    x && x();

    !u || u.p; // $ Alert
    !n || n.p; // $ Alert
    !o || o.p; // $ Alert
    !x || x.p;

    !!u && u.p; // $ Alert
    !!n && n.p; // $ Alert
    !!o && o.p; // $ Alert
    !!x && x.p;

    u != undefined && u.p; // $ Alert
    n != undefined && n.p; // $ Alert
    o != undefined && o.p; // $ Alert
    x != undefined && x.p;

    u == undefined || u.p; // $ Alert
    n == undefined || n.p; // $ Alert
    o == undefined || o.p; // $ Alert
    x == undefined || x.p;

    u === undefined || u.p; // $ Alert
    n === undefined || n.p; // $ Alert
    o === undefined || o.p; // $ Alert
    x === undefined || x.p;

    if (u) { // $ Alert
        u.p;
    }
    if (n) { // $ Alert
        n.p;
    }
    if (o) { // $ Alert
        o.p;
    }
    if (x) {
        x.p;
    }

    u? u():_; // $ Alert
    n? n(): _; // $ Alert
    o? o(): _; // $ Alert
    x? x(): _;

    if (u !== undefined) { // $ Alert
        u.p;
    }
    if (n !== undefined) { // $ Alert
        n.p;
    }
    if (o !== undefined) { // $ Alert
        o.p;
    }
    if (x !== undefined) {
        x.p;
    }

    if (u == undefined){} // $ Alert
    if (n == undefined){} // $ Alert
    if (o == undefined){} // $ Alert
    if (x == undefined){}

    if (u != undefined){} // $ Alert
    if (n != undefined){} // $ Alert
    if (o != undefined){} // $ Alert
    if (x != undefined){}

    if (typeof u === "undefined"){} // $ Alert
    if (typeof n === "undefined"){} // $ Alert
    if (typeof o === "undefined"){} // $ Alert
    if (typeof x === "undefined"){}

    function f() { }
    typeof f === "function" && f(); // $ Alert
    typeof u === "function" && u(); // $ Alert
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

    empty_array && empty_array.pop(); // $ Alert
    pseudo_empty_array && pseudo_empty_array.pop(); // $ Alert
    non_empty_array && non_empty_array.pop(); // $ Alert
    empty_string && empty_string.charAt(0);
    non_empty_string && non_empty_string.charAt(0);
    zero && zero();
    neg && neg();
    _true && _true();
    _false && _false();

    (u !== undefined && u !== null) && u.p; // $ Alert
    u !== undefined && u !== null && u.p; // $ Alert

    u != undefined && u != null; // $ Alert
    u == undefined || u == null; // $ Alert
    u !== undefined && u !== null; // $ Alert
    !(u === undefined) && !(u === null); // $ Alert
    u === undefined || u === null; // $ Alert
    !(u === undefined || u === null); // $ Alert
    !(u === undefined) && u !== null; // $ Alert
    u !== undefined && n !== null;
    u == undefined && u == null; // $ Alert
    x == undefined && x == null;

    x === undefined && x === null; // $ Alert
    if (x === undefined) {
        if (x === null) { // $ Alert
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

    x != undefined && x != null; // $ Alert
    if (x != undefined) {
        if (x != null) { // $ Alert
        }
    }

    if (typeof x !== undefined);
    if (typeof window !== undefined);
    if (typeof x !== x);
    if (typeof x !== u); // $ Alert

    if (typeof window !== "undefined");
    if (typeof module !== "undefined");
    if (typeof global !== "undefined");

    if (typeof window !== "undefined" && window.document);
    if (typeof module !== "undefined" && module.exports);
    if (typeof global !== "undefined" && global.process);

	u && (f(), u.p);
	u && (u.p, f()); // technically not OK, but it seems like an unlikely pattern
	u && !u.p; // $ Alert
	u && !u(); // $ Alert

    
    function hasCallbacks(success, error) {
        if (success) success()
        if (error) error()
    }
    hasCallbacks(() => {}, null);
});
