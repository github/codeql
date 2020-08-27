function f1() {
    var password = Math.random(); // NOT OK
}

function f2() {
    var password = "prefix" + Math.random(); // NOT OK
}

function f3() {
    var password = Math.random(); // NOT OK

    // (no complaining about further uses)
    f(password);
    password = 42;
    g(password);
}

function f4() {
    var suffix = Math.random() % 255;
    var password = "prefix" + suffix; // NOT OK
}

function f5() {
    var pw = Math.random(); // NOT OK, but our naming heuristic does not identify `pw` as sensitive [INCONSISTENCY]
}

function f6() {
    var pw = Math.random();
    var password = pw; // NOT OK
}

function f7() {
    var number = Math.random() // OK
}

function f8() {
    var password = someSecureRandomThing(); // OK
}

function f9() {
    var password = !Math.random(); // NOT OK
}

function f10() {
    var secret = Math.random(); // NOT OK
}

function f11() {
    var o = {};
    o.secret = Math.random() // NOT OK
}

function f12() {
    ({
        secret: Math.random() // NOT OK
    });
}

function f13() {
    ({
        secret: '' + Math.random() // NOT OK
    });
}

function f14() {
    var secret = Math.floor(Math.random()); // NOT OK
}

function f15() {
    var ts = new Date().getTime();
    var rand = Math.floor(Math.random()*9999999);
    var concat = ts.toString() + rand.toString();
    res.send({secret: concat}); // NOT OK
}

function f16() {
    function f(secret) { // NOT OK
        secret++;
    }
    f(Math.random());
}

function f17() {
    var secret1 = Math.random(); // NOT OK
    var secret2 = secret1; // OK (we flagged secret1 above)
    var secret3 = secret2; // OK (we flagged secret1 above)
}

function f18() {
    var secret = (o.password = Math.random());
}

(function(){
    var crypto = require('crypto');
    crypto.createHmac('sha256', Math.random());
})();

(function () {
    function genRandom() {
        if (window.crypto && crypto.getRandomValues && !isSafari()) {
            var a = window.crypto.getRandomValues(new Uint32Array(3)),
                token = '';
            for (var i = 0, l = a.length; i < l; i++) {
                token += a[i].toString(36);
            }
            return token;
        } else {
            return (Math.random() * new Date().getTime()).toString(36).replace(/\./g, '');
        }
    };
    var secret = genRandom(); // OK - Math.random() is only a fallback.
})();