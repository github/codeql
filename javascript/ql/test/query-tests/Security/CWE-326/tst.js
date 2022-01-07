const crypto = require("crypto");

const bad1 = crypto.generateKeyPairSync("rsa", { modulusLength: 1024 }); // NOT OK

const good1 = crypto.generateKeyPairSync("rsa", { modulusLength: 4096 }); // OK

const bad2 = crypto.generateKeySync("hmac", { length: 64 }); // NOT OK

const good2 = crypto.generateKeySync("aes", { length: 256 }); // OK

var CryptoJS = require("crypto-js");

const bad3 = CryptoJS.algo.PBKDF2.create({ keySize: 2 }); // NOT OK
const bad4 = CryptoJS.PBKDF2(password, salt, { keySize: 2 }); // NOT OK
const bad5 = CryptoJS.EvpKDF(password, salt, { keySize: 2 }); // NOT OK
const bad6 = CryptoJS.PBKDF2(password, salt, { keySize: 8 }); // OK

const forge = require("node-forge");
var bad7 = forge.rc2.createEncryptionCipher(password, 64); // NOT OK
var good3 = forge.rc2.createEncryptionCipher(password, 128); // OK

var key1 = forge.random.getBytesSync(16);
var good4 = forge.cipher.createCipher('AES-CBC', key1); // OK

var key2 = forge.random.getBytesSync(8);
var bad8 = forge.cipher.createCipher('AES-CBC', key2); // NOT OK

var myBuffer = forge.util.createBuffer(manyBytes);
var key3 = myBuffer.getBytes(8);
var bad9 = forge.cipher.createDecipher('3DES-CBC', key3); // NOT OK

var key4 = myBuffer.getBytes(16);
var good5 = forge.cipher.createDecipher('AES-CBC', key4); // OK

var bad10 = crypto.createDiffieHellman(512);
var good6 = crypto.createDiffieHellman(2048);

const NodeRSA = require('node-rsa');
var bad11 = new NodeRSA({b: 512}); // NOT OK
var good7 = new NodeRSA({b: 4096}); // OK

var key = new NodeRSA(); // OK
key.generateKeyPair(512, 65537); // NOT OK
key.generateKeyPair(4096, 65537); // OK