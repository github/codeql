asmCrypto.SHA256.hex(input);

var jwcrypto = require("browserid-crypto");
jwcrypto.generateKeypair({algorithm: 'DSA'}, function(err, keypair) {
    jwcrypto.sign(input, keypair.secretKey);
});

const crypto = require('crypto');
const cipher = crypto.createCipher('aes192', 'a password');
let encrypted1 = cipher.update('input1', 'utf8', 'hex');
let encrypted2 = cipher.write('input2', 'utf8', 'hex');

const crypto = require('crypto');
const hash = crypto.createHash('sha256');
hash.update('input1');
hash.write('input2');

const crypto = require('crypto');
const hmac = crypto.createHmac('sha256', 'a secret');
hmac.update('input1');
hmac.write('input2');

const crypto = require('crypto');
const sign = crypto.createSign('SHA256');
sign.update('input1');
sign.write('input2');

var CryptoJS = require("crypto-js");
CryptoJS.AES.encrypt('my message', 'secret key 123');

var CryptoJS = require("crypto-js");
CryptoJS.SHA1("Message", "Key");

var CryptoJS = require("crypto-js");
CryptoJS.HmacSHA1("Message", "Key");

require("crypto-js/aes").encrypt('my message', 'secret key 123');

require("crypto-js/sha1")("Message", "Key");

require("nacl").sign('my message');

require("nacl").hash('my message');

require("nacl-fast").sign('my message');

require("nacl-fast").hash('my message');

require('hash.js').sha256().update('abc').digest('hex')

require('hash.js/lib/hash/sha/512')().update('abc').digest('hex');

require("forge").md.md5.create().update('The quick brown fox jumps over the lazy dog');

require("node-forge").md.md5.create().update('The quick brown fox jumps over the lazy dog');

require("forge").rc2.createEncryptionCipher(key).update("secret");

require("forge").cipher.createCipher('3DES-CBC', key).update("secret");

require("md5")("message");

require("bcrypt").hash(password);

require("bcrypt").hashSync(password);

require("bcryptjs").hash(password);

require("bcrypt-nodejs").hash(password);

require('hasha')('unicorn', { algorithm: "md5" });

require("express-jwt").sign(m, "secret", {});
