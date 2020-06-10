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