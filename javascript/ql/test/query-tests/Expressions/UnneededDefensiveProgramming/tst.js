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

    u_ = u_ || e; // NOT OK
    n_ = n_ || e; // NOT OK
    o_ = o_ || e; // NOT OK
    x_ = x_ || e;

    u && u.p; // NOT OK
    n && n.p; // NOT OK
    o && o.p; // NOT OK
    x && x.p;

    u && u(); // NOT OK
    n && n(); // NOT OK
    o && o(); // NOT OK
    x && x();

    !u || u.p; // NOT OK
    !n || n.p; // NOT OK
    !o || o.p; // NOT OK
    !x || x.p;

    !!u && u.p; // NOT OK
    !!n && n.p; // NOT OK
    !!o && o.p; // NOT OK
    !!x && x.p;

    u != undefined && u.p; // NOT OK
    n != undefined && n.p; // NOT OK
    o != undefined && o.p; // NOT OK
    x != undefined && x.p;

    u == undefined || u.p; // NOT OK
    n == undefined || n.p; // NOT OK
    o == undefined || o.p; // NOT OK
    x == undefined || x.p;

    u === undefined || u.p; // NOT OK
    n === undefined || n.p; // NOT OK
    o === undefined || o.p; // NOT OK
    x === undefined || x.p;

    if (u) { // NOT OK
        u.p;
    }
    if (n) { // NOT OK
        n.p;
    }
    if (o) { // NOT OK
        o.p;
    }
    if (x) {
        x.p;
    }

    u? u():_; // NOT OK
    n? n(): _; // NOT OK
    o? o(): _; // NOT OK
    x? x(): _;

    if (u !== undefined) { // NOT OK
        u.p;
    }
    if (n !== undefined) { // NOT OK
        n.p;
    }
    if (o !== undefined) { // NOT OK
        o.p;
    }
    if (x !== undefined) {
        x.p;
    }

    if (u == undefined){} // NOT OK
    if (n == undefined){} // NOT OK
    if (o == undefined){} // NOT OK
    if (x == undefined){}

    if (u != undefined){} // NOT OK
    if (n != undefined){} // NOT OK
    if (o != undefined){} // NOT OK
    if (x != undefined){}

    if (typeof u === "undefined"){} // NOT OK
    if (typeof n === "undefined"){} // NOT OK
    if (typeof o === "undefined"){} // NOT OK
    if (typeof x === "undefined"){}

    function f() { }
    typeof f === "function" && f(); // NOT OK
    typeof u === "function" && u(); // NOT OK
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

    empty_array && empty_array.pop(); // NOT OK
    pseudo_empty_array && pseudo_empty_array.pop(); // NOT OK
    non_empty_array && non_empty_array.pop(); // NOT OK
    empty_string && empty_string.charAt(0);
    non_empty_string && non_empty_string.charAt(0);
    zero && zero();
    neg && neg();
    _true && _true();
    _false && _false();

    (u !== undefined && u !== null) && u.p; // NOT OK
    u !== undefined && u !== null && u.p; // NOT OK

    u != undefined && u != null; // NOT OK
    u == undefined || u == null; // NOT OK
    u !== undefined && u !== null; // NOT OK
    !(u === undefined) && !(u === null); // NOT OK
    u === undefined || u === null; // NOT OK
    !(u === undefined || u === null); // NOT OK
    !(u === undefined) && u !== null; // NOT OK
    u !== undefined && n !== null;
    u == undefined && u == null; // NOT OK
    x == undefined && x == null;

    x === undefined && x === null; // NOT OK
    if (x === undefined) {
        if (x === null) { // NOT OK
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

    x != undefined && x != null; // NOT OK
    if (x != undefined) {
        if (x != null) { // NOT OK
        }
    }

    if (typeof x !== undefined);
    if (typeof window !== undefined);
    if (typeof x !== x);
    if (typeof x !== u); // NOT OK

    if (typeof window !== "undefined");
    if (typeof module !== "undefined");
    if (typeof global !== "undefined");

    if (typeof window !== "undefined" && window.document);
    if (typeof module !== "undefined" && module.exports);
    if (typeof global !== "undefined" && global.process);

	u && (f(), u.p);
	u && (u.p, f()); // technically not OK, but it seems like an unlikely pattern
	u && !u.p; // NOT OK
	u && !u(); // NOT OK
});
