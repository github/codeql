const crypto = require("crypto");

const bad1 = crypto.generateKeyPairSync("rsa", { modulusLength: 1024 }); // $ Alert

const good1 = crypto.generateKeyPairSync("rsa", { modulusLength: 4096 });

const bad2 = crypto.generateKeySync("hmac", { length: 64 }); // $ Alert

const good2 = crypto.generateKeySync("aes", { length: 256 });

var CryptoJS = require("crypto-js");

const bad3 = CryptoJS.algo.PBKDF2.create({ keySize: 2 }); // $ Alert
const bad4 = CryptoJS.PBKDF2(password, salt, { keySize: 2 }); // $ Alert
const bad5 = CryptoJS.EvpKDF(password, salt, { keySize: 2 }); // $ Alert
const bad6 = CryptoJS.PBKDF2(password, salt, { keySize: 8 });

const forge = require("node-forge");
var bad7 = forge.rc2.createEncryptionCipher(password, 64); // $ Alert
var good3 = forge.rc2.createEncryptionCipher(password, 128);

var key1 = forge.random.getBytesSync(16);
var good4 = forge.cipher.createCipher('AES-CBC', key1);

var key2 = forge.random.getBytesSync(8);
var bad8 = forge.cipher.createCipher('AES-CBC', key2); // $ Alert

var myBuffer = forge.util.createBuffer(manyBytes);
var key3 = myBuffer.getBytes(8);
var bad9 = forge.cipher.createDecipher('3DES-CBC', key3); // $ Alert

var key4 = myBuffer.getBytes(16);
var good5 = forge.cipher.createDecipher('AES-CBC', key4);

var bad10 = crypto.createDiffieHellman(512); // $ Alert
var good6 = crypto.createDiffieHellman(2048);

const NodeRSA = require('node-rsa');
var bad11 = new NodeRSA({b: 512}); // $ Alert
var good7 = new NodeRSA({b: 4096});

var key = new NodeRSA();
key.generateKeyPair(512, 65537); // $ Alert
key.generateKeyPair(4096, 65537);