function SanitizingRegExpTest () {
    var v = SOURCE();
    SINK(v);

    if (/^x$/.test(v)) {
        SINK(v); // sanitized
    } else {
        SINK(v);
    }

    if (v.match(/[^a-z]/)) {
        SINK(v);
    } else {
        SINK(v); // sanitized
    }

}

function HasOwnPropertySanitizer () {
    var v = SOURCE();
    SINK(v);

    if (o.hasOwnProperty(v)) {
        SINK(v);
    } else {
        SINK(v);
    }

}

function InSanitizer () {
    var v = SOURCE();
    SINK(v);

    if (v in o) {
        SINK(v);
    } else {
        SINK(v);
    }

}

function UndefinedCheckSanitizer () {
    var v = SOURCE();
    SINK(v);

	if (o[v] == undefined) {
        SINK(v);
    } else {
        SINK(v);
    }

    if (undefined === o[v]) {
        SINK(v);
    } else {
        SINK(v);
    }

    if (o[v] !== undefined) {
        SINK(v);
    } else {
        SINK(v);
    }

}

function IndexOfCheckSanitizer () {
    var v = SOURCE();
    SINK(v);

    if (o.indexOf(v) == -1) {
        SINK(v);
    } else {
        SINK(v);
    }

    if (-1 === o.indexOf(v)) {
        SINK(v);
    } else {
        SINK(v);
    }

    if (o.indexOf(v) !== -1) {
        SINK(v);
    } else {
        SINK(v);
    }

}

function containsSanitizer () {
    var v = SOURCE();
    SINK(v);

    if (o.contains(v)) {
        SINK(v);
    } else {
        SINK(v);
    }

}

function hasSanitizer () {
    var v = SOURCE();
    SINK(v);

    if (o.has(v)) {
        SINK(v);
    } else {
        SINK(v);
    }

}

function includesSanitizer () {
    var v = SOURCE();
    SINK(v);

    if (o.includes(v)) {
        SINK(v);
    } else {
        SINK(v);
    }

}

function propertySanitization(o) {
    var v = SOURCE();
    SINK(v.p.q);

    if (o.hasOwnProperty(v)) {
        SINK(v);
    } else if (o.hasOwnProperty(v.p)) {
        SINK(v.p);
    } else if (o.hasOwnProperty(v.p.q)) {
        SINK(v.p.q);
    } else if (o.hasOwnProperty(v.p)) {
        SINK(v);
    } else if (o.hasOwnProperty(v["p.q"])) {
        SINK(v.p.q);
    }
}

function constantComparisonSanitizer () {
    var v = SOURCE();
    SINK(v);

    if (v == "white-listed") {
        SINK(v);
    } else {
        SINK(v);
    }

    if ("white-listed" != v) {
        SINK(v);
    } else {
        SINK(v);
    }

    if (v === "white-listed-1" || v === "white-listed-2") {
        SINK(v);
    } else {
        SINK(v);
    }

    if (v == !!0) {
        SINK(v);
    } else {
        SINK(v);
    }
}

function customSanitizer() {
    function SANITIZE(x){ return x; }
    var v = SOURCE();
    v = SANITIZE(v);
    SINK(v);
}

function BitwiseIndexOfCheckSanitizer () {
    var v = SOURCE();
    SINK(v);

    if (~o.indexOf(v)) {
        SINK(v);
    } else {
        SINK(v);
    }

    if (!~o.indexOf(v)) {
        SINK(v);
    } else {
        SINK(v);
    }

}

function RelationalIndexOfCheckSanitizer () {
    var v = SOURCE();
    SINK(v);

    if (o.indexOf(v) <= -1) {
        SINK(v);
    } else {
        SINK(v);
    }

    if (o.indexOf(v) >= 0) {
        SINK(v);
    } else {
        SINK(v);
    }

    if (o.indexOf(v) < 0) {
        SINK(v);
    } else {
        SINK(v);
    }

    if (o.indexOf(v) > -1) {
        SINK(v);
    } else {
        SINK(v);
    }

    if (-1 >= o.indexOf(v)) {
        SINK(v);
    } else {
        SINK(v);
    }

}

function adhocWhitelisting() {
    var v = SOURCE();
    if (isWhitelisted(v))
        SINK(v);
    else
        SINK(v);
    if (config.allowValue(v))
        SINK(v);
    else
        SINK(v);

}

function IndirectSanitizer () {
    var v = SOURCE();
    SINK(v);

    function f(x) {
        return whitelist.contains(x);
    }
    if (f(v)) {
        SINK(v);
    } else {
        SINK(v);
    }

    function g(y) {
        var sanitized = whitelist.contains(y);
        return sanitized;
    }
    if (g(v)) {
        SINK(v);
    } else {
        SINK(v);
    }

    function h(z) {
        var sanitized = whitelist.contains(z);
        return somethingElse();
    }
    if (h(v)) {
        SINK(v);
    } else {
        SINK(v);
    }

    function f2(x2) {
        return x2 != null && whitelist.contains(x2);
    }
    if (f2(v)) {
        SINK(v);
    } else {
        SINK(v);
    }

    function f3(x3) {
        return x3 == null || whitelist.contains(x3);
    }
    if (f3(v)) {
        SINK(v); // SANITIZATION OF THIS IS NOT YET SUPPORTED
    } else {
        SINK(v);
    }

    function f4(x4) {
        return !whitelist.contains(x4);
    }
    if (f4(v)) {
        SINK(v);
    } else {
        SINK(v); // SANITIZATION OF THIS IS NOT YET SUPPORTED
    }

    function f5(x5) {
        return !!whitelist.contains(x5);
    }
    if (f5(v)) {
        SINK(v); // SANITIZATION OF THIS IS NOT YET SUPPORTED
    } else {
        SINK(v);
    }

    function f6(x6) {
        var sanitized = !whitelist.contains(x6);
        return !sanitized;
    }
    if (f6(v)) {
        SINK(v);
    } else {
        SINK(v); // SANITIZATION OF THIS IS NOT YET SUPPORTED
    }

    function f7(x7) {
        var sanitized = x7 != null && whitelist.contains(x7);
        return sanitized;
    }
    if (f7(v)) {
        SINK(v);
    } else {
        SINK(v);
    }

    function f8(x8) {
        var sanitized = whitelist.contains(x8);
        return x8 != null && sanitized;
    }
    if (f8(v)) {
        SINK(v); // SANITIZATION OF THIS IS NOT YET SUPPORTED
    } else {
        SINK(v);
    }

    function f9(x9) {
        return unknown() && whitelist.contains(x9) && unknown();
    }
    if (f9(v)) {
        SINK(v);
    } else {
        SINK(v);
    }

    function f10(x10) {
        return x10 !== null || x10 !== undefined;
    }
    if (f10(v)) {
        SINK(v);
    } else {
        SINK(v);
    }

}

function constantComparisonSanitizer2() {
    var o = SOURCE();
    SINK(o.p); // flagged

    if (o.p == "white-listed") {
        SINK(o.p); // not flagged
    } else {
        SINK(o.p); // flagged
    }

    for (var p in o) {
      if (o[p] == "white-listed") {
        SINK(o[p]); // not flagged
        p = somethingElse();
        SINK(o[p]); // flagged
      } else {
        SINK(o[p]); // flagged
      }
    }
}
