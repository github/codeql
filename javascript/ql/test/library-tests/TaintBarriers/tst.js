function SanitizingRegExpTest () {
    var v = SOURCE();
    SINK(v);

    if (/x/.test(v)) {
        SINK(v);
    } else {
        SINK(v);
    }

    if (v.match(/x/)) {
        SINK(v);
    } else {
        SINK(v);
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
