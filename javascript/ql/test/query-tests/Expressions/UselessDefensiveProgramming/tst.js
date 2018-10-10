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

    u_ = u_ || e;
    n_ = n_ || e;
    o_ = o_ || e;
    x_ = x_ || e;

    u && u.p;
    n && n.p;
    o && o.p;
    x && x.p;

    u && u();
    n && n();
    o && o();
    x && x();

    !u || u.p;
    !n || n.p;
    !o || o.p;
    !x || x.p;

    !!u && u.p;
    !!n && n.p;
    !!o && o.p;
    !!x && x.p;

    u != undefined && u.p;
    n != undefined && n.p;
    o != undefined && o.p;
    x != undefined && x.p;

    u == undefined || u.p;
    n == undefined || n.p;
    o == undefined || o.p;
    x == undefined || x.p;

    u === undefined || u.p;
    n === undefined || n.p;
    o === undefined || o.p; // T, D
    x === undefined || x.p;

    if (u) {
        u.p;
    }
    if (n) {
        n.p;
    }
    if (o) {
        o.p;
    }
    if (x) {
        x.p;
    }

    u? u():_;
    n? n(): _;
    o? o(): _;
    x? x(): _;

    if (u !== undefined) {
        u.p;
    }
    if (n !== undefined) {
        n.p;
    }
    if (o !== undefined) {
        o.p;
    }
    if (x !== undefined) {
        x.p;
    }

    if (u == undefined){}
    if (n == undefined){}
    if (o == undefined){}
    if (x == undefined){}

    if (u != undefined){}
    if (n != undefined){}
    if (o != undefined){}
    if (x != undefined){}

    if (typeof u === "undefined"){}
    if (typeof n === "undefined"){}
    if (typeof o === "undefined"){}
    if (typeof x === "undefined"){}

    function f() { }
    typeof f === "function" && f();
    typeof u === "function" && u();
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

    empty_array && empty_array.pop();
    pseudo_empty_array && pseudo_empty_array.pop();
    non_empty_array && non_empty_array.pop();
    empty_string && empty_string.charAt(0);
    non_empty_string && non_empty_string.charAt(0);
    zero && zero();
    neg && neg();
    _true && _true();
    _false && _false();D

    (u !== undefined && u !== null) && u.p;
    u !== undefined && u !== null && u.p;

    u != undefined && u != null;
    u == undefined || u == null;
    u !== undefined && u !== null;
    !(u === undefined) && !(u === null);
    u === undefined || u === null;
    !(u === undefined || u === null);
    !(u === undefined) && u !== null;
    u !== undefined && n !== null;
    u == undefined && u == null;
    x == undefined && x == null;

    x === undefined && x === null;
    if (x === undefined) {
        if (x === null) {
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

    x != undefined && x != null;
    if (x != undefined) {
        if (x != null) {
        }
    }

    if (typeof x !== undefined);
    if (typeof window !== undefined);
    if (typeof x !== x);
    if (typeof x !== u);

    if (typeof window !== "undefined");
    if (typeof module !== "undefined");
    if (typeof global !== "undefined");

    if (typeof window !== "undefined" && window.document);
    if (typeof module !== "undefined" && module.exports);
    if (typeof global !== "undefined" && global.process);
});
