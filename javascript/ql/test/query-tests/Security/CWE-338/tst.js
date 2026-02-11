function f1() {
    var password = Math.random(); // $ Alert
}

function f2() {
    var password = "prefix" + Math.random(); // $ Alert
}

function f3() {
    var password = Math.random(); // $ Alert

    // (no complaining about further uses)
    f(password);
    password = 42;
    g(password);
}

function f4() {
    var suffix = Math.random() % 255; // $ Source
    var password = "prefix" + suffix; // $ Alert
}

function f5() {
    var pw = Math.random(); // $ MISSING: Alert - our naming heuristic does not identify `pw` as sensitive
}

function f6() {
    var pw = Math.random(); // $ Source
    var password = pw; // $ Alert
}

function f7() {
    var number = Math.random()
}

function f8() {
    var password = someSecureRandomThing();
}

function f9() {
    var password = !Math.random(); // $ Alert
}

function f10() {
    var secret = Math.random(); // $ Alert
}

function f11() {
    var o = {};
    o.secret = Math.random() // $ Alert
}

function f12() {
    ({
        secret: Math.random() // $ Alert
    });
}

function f13() {
    ({
        secret: '' + Math.random() // $ Alert
    });
}

function f14() {
    var secret = Math.floor(Math.random()); // $ Alert
}

function f15() {
    var ts = new Date().getTime();
    var rand = Math.floor(Math.random()*9999999); // $ Source
    var concat = ts.toString() + rand.toString();
    res.send({secret: concat}); // $ Alert
}

function f16() {
    function f(secret) { // $ Alert
        secret++;
    }
    f(Math.random()); // $ Source
}

function f17() {
    var secret1 = Math.random(); // $ Alert
    var secret2 = secret1; // OK - we flagged secret1 above
    var secret3 = secret2; // OK - we flagged secret1 above
}

function f18() {
    var secret = (o.password = Math.random()); // $ Alert
}

(function(){
    var crypto = require('crypto');
    crypto.createHmac('sha256', Math.random()); // $ Alert
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

function uid() {
    var uuid = Math.floor(Math.random() * 4_000_000_000); // $ Alert
    var sessionUid = Math.floor(Math.random() * 4_000_000_000); // $ Alert
    var uid = Math.floor(Math.random() * 4_000_000_000); // $ Alert
    var my_nice_uid = Math.floor(Math.random() * 4_000_000_000); // $ Alert
    var liquid = Math.random();
    var UUID = Math.random(); // $ Alert
    var MY_UID = Math.random(); // $ Alert
}

function buildPass(opts, length) {
    const digits = '0123456789'.split('');
    const letters = 'abcdefghijklmnopqrstuvwxyz'.split('');
    const specials = '!@#$%^&*()_+{}|:"<>?[];\',./`~'.split('');

    const chars = [];
    opts.digits && chars.push(...digits);
    opts.letters && chars.push(...letters);
    opts.specials && chars.push(...specials);

    const password = "";
    for (let i = 0; i < length; i++) {
        password += chars[Math.floor(Math.random() * chars.length)]; // $ Alert
    }
    return password;
}
