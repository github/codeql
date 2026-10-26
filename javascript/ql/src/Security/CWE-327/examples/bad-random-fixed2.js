const crypto = require('crypto');

const digits = [];
while (digits.length < 10) {
    const byte = crypto.randomBytes(1)[0];
    if (byte >= 250) {
        continue;
    }
    digits.push(byte % 10); // OK
}