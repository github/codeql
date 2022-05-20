const crypto = require('crypto');

var bad = crypto.randomBytes(1)[0] + crypto.randomBytes(1)[0]; // NOT OK
var bad = crypto.randomBytes(1)[0] * crypto.randomBytes(1)[0]; // NOT OK

const buffer = crypto.randomBytes(bytes);
const digits = [];
for (let i = 0; i < buffer.length; ++i) {
    digits.push(Math.floor(buffer[i] / 25.6)); // NOT OK
    digits.push(buffer[i] % 8); // OK - input is a random byte, so the output is a uniformly random number between 0 and 7. 
    digits.push(buffer[i] % 100); // NOT OK
}

var bad = Number('0.' + crypto.randomBytes(3).readUIntBE(0, 3)); // NOT OK
var good = Number(10 + crypto.randomBytes(3).readUIntBE(0, 3)); // OK

const internals = {};
exports.randomDigits = function (size) {
    const digits = [];

    let buffer = internals.random(size * 2);
    let pos = 0;

    while (digits.length < size) {
        if (pos >= buffer.length) {
            buffer = internals.random(size * 2);
            pos = 0;
        }

        if (buffer[pos] < 250) {
            digits.push(buffer[pos] % 10); // GOOD - protected by a bias-checking comparison.
        }
        ++pos;
    }

    return digits.join('');
};

internals.random = function (bytes) {
    try {
        return crypto.randomBytes(bytes);
    }
    catch (err) {
        throw new Error("Failed to make bits.");
    }
};

exports.randomDigits2 = function (size) {
    const digits = [];

    let buffer = crypto.randomBytes(size * 2);
    let pos = 0;

    while (digits.length < size) {
        if (pos >= buffer.length) {
            buffer = internals.random(size * 2);
            pos = 0;
        }
        var num = buffer[pos];
        if (num < 250) {
            digits.push(num % 10); // GOOD - protected by a bias-checking comparison.
        }
        ++pos;
    }

    return digits.join('');
};

function setSteps() {
    const buffer = crypto.randomBytes(bytes);
    const digits = [];
    for (const byte of buffer.values()) {
        digits.push(Math.floor(byte / 25.6)); // NOT OK
        digits.push(byte % 8); // OK - 8 is a power of 2, so the result is unbiased.
        digits.push(byte % 100); // NOT OK
    }
}

const secureRandom = require("secure-random");

var bad = secureRandom(10)[0] + secureRandom(10)[0]; // NOT OK

var goodRandom1 = 5 + secureRandom(10)[0];
var goodRandom2 = 5 + secureRandom(10)[0];
var bad = goodRandom1 + goodRandom2; // NOT OK

var dontFlag = bad + bad; // OK - the operands have already been flagged - but flagged anyway due to us not detecting that [INCONSISTENCY].

var good = secureRandom(10)[0] / 0xff; // OK - result is not rounded. 
var good = Math.ceil(0.5 - (secureRandom(10)[0] / 25.6)); // NOT OK - division generally introduces bias - but not flagged due to not looking through nested arithmetic. 

var good = (crypto.randomBytes(1)[0] << 8) + crypto.randomBytes(3)[0]; // OK - bit shifts are usually used to construct larger/smaller numbers, 

var good = Math.floor(max * (crypto.randomBytes(1)[0] / 0xff)); // OK - division by 0xff (255) gives a uniformly random number between 0 and 1. 

var bad = Math.floor(max * (crypto.randomBytes(1)[0] / 100)); // NOT OK - division by 100 gives bias - but not flagged due to not looking through nested arithmetic. 

var crb = crypto.randomBytes(4);
var cryptoRand = 0x01000000 * crb[0] + 0x00010000 * crb[1] + 0x00000100 * crb[2] + 0x00000001 * crb[3]; // OK - producing a larger number from smaller numbers.

var good = (secureRandom(10)[0] + "foo") + (secureRandom(10)[0] + "bar"); // OK - string concat

var eight = 8;
var good = crypto.randomBytes(4)[0] % eight; // OK - modulo by power of 2.

var twoHundredAndFiftyFive = 0xff;
var good = Math.floor(max * (crypto.randomBytes(1)[0] / twoHundredAndFiftyFive)); // OK - division by 0xff (255) gives a uniformly random number between 0 and 1. 

var a = crypto.randomBytes(10);
var good = ((a[i] & 31) * 0x1000000000000) + (a[i + 1] * 0x10000000000) + (a[i + 2] * 0x100000000) + (a[i + 3] * 0x1000000) + (a[i + 4] << 16) + (a[i + 5] << 8) + a[i + 6]; // OK - generating a large number from smaller bytes.
var good = (a[i] * 0x100000000) + a[i + 6]; // OK - generating a large number from smaller bytes.
var good = (a[i + 2] * 0x10000000) + a[i + 6]; // OK - generating a large number from smaller bytes.
var foo = 0xffffffffffff + 0xfffffffffff + 0xffffffffff + 0xfffffffff + 0xffffffff + 0xfffffff + 0xffffff

// Bad documentation example: 
const digits = [];
for (let i = 0; i < 10; i++) {
    digits.push(crypto.randomBytes(1)[0] % 10); // NOT OK
}

// Good documentation example: 
const digits = [];
while (digits.length < 10) {
    const byte = crypto.randomBytes(1)[0];
    if (byte >= 250) {
        continue;
    }
    digits.push(byte % 10); // OK
}