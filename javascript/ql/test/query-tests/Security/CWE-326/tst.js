const crypto = require("crypto");

const bad1 = crypto.generateKeyPairSync("rsa", { modulusLength: 1024 }); // NOT OK

const good1 = crypto.generateKeyPairSync("rsa", { modulusLength: 4096 }); // OK

const bad2 = crypto.generateKeySync("hmac", { length: 64 }); // NOT OK

const good2 = crypto.generateKeySync("aes", { length: 256 }); // OK

var CryptoJS = require("crypto-js");

const bad3 = CryptoJS.algo.PBKDF2.create({ keySize: 2 }); // NOT OK
const bad4 = CryptoJS.PBKDF2(password, salt, { keySize: 2 }); // NOT OK
const bad5 = CryptoJS.EvpKDF(password, salt, { keySize: 2 }); // NOT OK
const bad4 = CryptoJS.PBKDF2(password, salt, { keySize: 8 }); // OK