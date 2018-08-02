// Automatically generated from TypeScript type definitions provided by
// DefinitelyTyped (https://github.com/DefinitelyTyped/DefinitelyTyped),
// which is licensed under the MIT license; see file DefinitelyTyped-LICENSE
// in parent directory.
// Type definitions for Node.js 10.5.x
// Project: http://nodejs.org/
// Definitions by: Microsoft TypeScript <http://typescriptlang.org>
//                 DefinitelyTyped <https://github.com/DefinitelyTyped/DefinitelyTyped>
//                 Parambir Singh <https://github.com/parambirs>
//                 Christian Vaagland Tellnes <https://github.com/tellnes>
//                 Wilco Bakker <https://github.com/WilcoBakker>
//                 Nicolas Voigt <https://github.com/octo-sniffle>
//                 Chigozirim C. <https://github.com/smac89>
//                 Flarna <https://github.com/Flarna>
//                 Mariusz Wiktorczyk <https://github.com/mwiktorczyk>
//                 wwwy3y3 <https://github.com/wwwy3y3>
//                 Deividas Bakanas <https://github.com/DeividasBakanas>
//                 Kelvin Jin <https://github.com/kjin>
//                 Alvis HT Tang <https://github.com/alvis>
//                 Sebastian Silbermann <https://github.com/eps1lon>
//                 Hannes Magnusson <https://github.com/Hannes-Magnusson-CK>
//                 Alberto Schiabel <https://github.com/jkomyno>
//                 Klaus Meinhardt <https://github.com/ajafff>
//                 Huw <https://github.com/hoo29>
//                 Nicolas Even <https://github.com/n-e>
//                 Bruno Scheufler <https://github.com/brunoscheufler>
//                 Mohsen Azimi <https://github.com/mohsen1>
//                 Hoàng Văn Khải <https://github.com/KSXGitHub>
//                 Alexander T. <https://github.com/a-tarasyuk>
//                 Lishude <https://github.com/islishude>
//                 Andrew Makarov <https://github.com/r3nya>
//                 Zane Hannan AU <https://github.com/ZaneHannanAU>
// Definitions: https://github.com/DefinitelyTyped/DefinitelyTyped

/**
 * @externs
 * @fileoverview Definitions for module "crypto"
 */

var crypto = {};

/**
 * @interface
 */
crypto.Certificate = function() {};

/**
 * @param {(string|Buffer)} spkac
 * @return {Buffer}
 */
crypto.Certificate.prototype.exportChallenge = function(spkac) {};

/**
 * @param {(string|Buffer)} spkac
 * @return {Buffer}
 */
crypto.Certificate.prototype.exportPublicKey = function(spkac) {};

/**
 * @param {Buffer} spkac
 * @return {boolean}
 */
crypto.Certificate.prototype.verifySpkac = function(spkac) {};

/**
 * @return {crypto.Certificate}
 */
crypto.Certificate = function() {};

/**
 * @return {crypto.Certificate}
 * @constructor
 */
crypto.Certificate = function() {};


/**
 * @type {boolean}
 */
crypto.fips;

/**
 * @interface
 */
crypto.CredentialDetails = function() {};

/**
 * @type {string}
 */
crypto.CredentialDetails.prototype.pfx;

/**
 * @type {string}
 */
crypto.CredentialDetails.prototype.key;

/**
 * @type {string}
 */
crypto.CredentialDetails.prototype.passphrase;

/**
 * @type {string}
 */
crypto.CredentialDetails.prototype.cert;

/**
 * @type {(string|Array<string>)}
 */
crypto.CredentialDetails.prototype.ca;

/**
 * @type {(string|Array<string>)}
 */
crypto.CredentialDetails.prototype.crl;

/**
 * @type {string}
 */
crypto.CredentialDetails.prototype.ciphers;

/**
 * @interface
 */
crypto.Credentials = function() {};

/**
 * @type {*}
 */
crypto.Credentials.prototype.context;

/**
 * @param {crypto.CredentialDetails} details
 * @return {crypto.Credentials}
 */
crypto.createCredentials = function(details) {};

/**
 * @param {string} algorithm
 * @return {crypto.Hash}
 */
crypto.createHash = function(algorithm) {};

/**
 * @param {string} algorithm
 * @param {(string|Buffer)} key
 * @return {crypto.Hmac}
 */
crypto.createHmac = function(algorithm, key) {};

/**
 * @interface
 * @extends {NodeJS.ReadWriteStream}
 */
crypto.Hash = function() {};

/**
 * @param {(string|Buffer)} data
 * @return {crypto.Hash}
 */
crypto.Hash.prototype.update = function(data) {};

/**
 * @param {(string|Buffer)} data
 * @param {(string)} input_encoding
 * @return {crypto.Hash}
 */
crypto.Hash.prototype.update = function(data, input_encoding) {};

/**
 * @return {Buffer}
 */
crypto.Hash.prototype.digest = function() {};

/**
 * @param {(string)} encoding
 * @return {string}
 */
crypto.Hash.prototype.digest = function(encoding) {};

/**
 * @interface
 * @extends {NodeJS.ReadWriteStream}
 */
crypto.Hmac = function() {};

/**
 * @param {(string|Buffer)} data
 * @return {crypto.Hmac}
 */
crypto.Hmac.prototype.update = function(data) {};

/**
 * @param {(string|Buffer)} data
 * @param {(string)} input_encoding
 * @return {crypto.Hmac}
 */
crypto.Hmac.prototype.update = function(data, input_encoding) {};

/**
 * @return {Buffer}
 */
crypto.Hmac.prototype.digest = function() {};

/**
 * @param {(string)} encoding
 * @return {string}
 */
crypto.Hmac.prototype.digest = function(encoding) {};

/**
 * @param {string} algorithm
 * @param {*} password
 * @return {crypto.Cipher}
 */
crypto.createCipher = function(algorithm, password) {};

/**
 * @param {string} algorithm
 * @param {*} key
 * @param {*} iv
 * @return {crypto.Cipher}
 */
crypto.createCipheriv = function(algorithm, key, iv) {};

/**
 * @interface
 * @extends {NodeJS.ReadWriteStream}
 */
crypto.Cipher = function() {};

/**
 * @param {Buffer} data
 * @return {Buffer}
 */
crypto.Cipher.prototype.update = function(data) {};

/**
 * @param {string} data
 * @param {(string)} input_encoding
 * @return {Buffer}
 */
crypto.Cipher.prototype.update = function(data, input_encoding) {};

/**
 * @param {Buffer} data
 * @param {*} input_encoding
 * @param {(string)} output_encoding
 * @return {string}
 */
crypto.Cipher.prototype.update = function(data, input_encoding, output_encoding) {};

/**
 * @param {string} data
 * @param {(string)} input_encoding
 * @param {(string)} output_encoding
 * @return {string}
 */
crypto.Cipher.prototype.update = function(data, input_encoding, output_encoding) {};

/**
 * @return {Buffer}
 */
crypto.Cipher.prototype.final = function() {};

/**
 * @param {string} output_encoding
 * @return {string}
 */
crypto.Cipher.prototype.final = function(output_encoding) {};

/**
 * @param {boolean=} auto_padding
 * @return {void}
 */
crypto.Cipher.prototype.setAutoPadding = function(auto_padding) {};

/**
 * @return {Buffer}
 */
crypto.Cipher.prototype.getAuthTag = function() {};

/**
 * @param {Buffer} buffer
 * @return {void}
 */
crypto.Cipher.prototype.setAAD = function(buffer) {};

/**
 * @param {string} algorithm
 * @param {*} password
 * @return {crypto.Decipher}
 */
crypto.createDecipher = function(algorithm, password) {};

/**
 * @param {string} algorithm
 * @param {*} key
 * @param {*} iv
 * @return {crypto.Decipher}
 */
crypto.createDecipheriv = function(algorithm, key, iv) {};

/**
 * @interface
 * @extends {NodeJS.ReadWriteStream}
 */
crypto.Decipher = function() {};

/**
 * @param {Buffer} data
 * @return {Buffer}
 */
crypto.Decipher.prototype.update = function(data) {};

/**
 * @param {string} data
 * @param {(string)} input_encoding
 * @return {Buffer}
 */
crypto.Decipher.prototype.update = function(data, input_encoding) {};

/**
 * @param {Buffer} data
 * @param {*} input_encoding
 * @param {(string)} output_encoding
 * @return {string}
 */
crypto.Decipher.prototype.update = function(data, input_encoding, output_encoding) {};

/**
 * @param {string} data
 * @param {(string)} input_encoding
 * @param {(string)} output_encoding
 * @return {string}
 */
crypto.Decipher.prototype.update = function(data, input_encoding, output_encoding) {};

/**
 * @return {Buffer}
 */
crypto.Decipher.prototype.final = function() {};

/**
 * @param {string} output_encoding
 * @return {string}
 */
crypto.Decipher.prototype.final = function(output_encoding) {};

/**
 * @param {boolean=} auto_padding
 * @return {void}
 */
crypto.Decipher.prototype.setAutoPadding = function(auto_padding) {};

/**
 * @param {Buffer} tag
 * @return {void}
 */
crypto.Decipher.prototype.setAuthTag = function(tag) {};

/**
 * @param {Buffer} buffer
 * @return {void}
 */
crypto.Decipher.prototype.setAAD = function(buffer) {};

/**
 * @param {string} algorithm
 * @return {crypto.Signer}
 */
crypto.createSign = function(algorithm) {};

/**
 * @interface
 * @extends {NodeJS.WritableStream}
 */
crypto.Signer = function() {};

/**
 * @param {(string|Buffer)} data
 * @return {crypto.Signer}
 */
crypto.Signer.prototype.update = function(data) {};

/**
 * @param {(string|Buffer)} data
 * @param {(string)} input_encoding
 * @return {crypto.Signer}
 */
crypto.Signer.prototype.update = function(data, input_encoding) {};

/**
 * @param {(string|{key: string, passphrase: string})} private_key
 * @return {Buffer}
 */
crypto.Signer.prototype.sign = function(private_key) {};

/**
 * @param {(string|{key: string, passphrase: string})} private_key
 * @param {(string)} output_format
 * @return {string}
 */
crypto.Signer.prototype.sign = function(private_key, output_format) {};

/**
 * @param {string} algorith
 * @return {crypto.Verify}
 */
crypto.createVerify = function(algorith) {};

/**
 * @interface
 * @extends {NodeJS.WritableStream}
 */
crypto.Verify = function() {};

/**
 * @param {(string|Buffer)} data
 * @return {crypto.Verify}
 */
crypto.Verify.prototype.update = function(data) {};

/**
 * @param {(string|Buffer)} data
 * @param {(string)} input_encoding
 * @return {crypto.Verify}
 */
crypto.Verify.prototype.update = function(data, input_encoding) {};

/**
 * @param {string} object
 * @param {Buffer} signature
 * @return {boolean}
 */
crypto.Verify.prototype.verify = function(object, signature) {};

/**
 * @param {string} object
 * @param {string} signature
 * @param {(string)} signature_format
 * @return {boolean}
 */
crypto.Verify.prototype.verify = function(object, signature, signature_format) {};

/**
 * @param {number} prime_length
 * @param {number=} generator
 * @return {crypto.DiffieHellman}
 */
crypto.createDiffieHellman = function(prime_length, generator) {};

/**
 * @param {Buffer} prime
 * @return {crypto.DiffieHellman}
 */
crypto.createDiffieHellman = function(prime) {};

/**
 * @param {string} prime
 * @param {(string)} prime_encoding
 * @return {crypto.DiffieHellman}
 */
crypto.createDiffieHellman = function(prime, prime_encoding) {};

/**
 * @param {string} prime
 * @param {(string)} prime_encoding
 * @param {(number|Buffer)} generator
 * @return {crypto.DiffieHellman}
 */
crypto.createDiffieHellman = function(prime, prime_encoding, generator) {};

/**
 * @param {string} prime
 * @param {(string)} prime_encoding
 * @param {string} generator
 * @param {(string)} generator_encoding
 * @return {crypto.DiffieHellman}
 */
crypto.createDiffieHellman = function(prime, prime_encoding, generator, generator_encoding) {};

/**
 * @interface
 */
crypto.DiffieHellman = function() {};

/**
 * @return {Buffer}
 */
crypto.DiffieHellman.prototype.generateKeys = function() {};

/**
 * @param {(string)} encoding
 * @return {string}
 */
crypto.DiffieHellman.prototype.generateKeys = function(encoding) {};

/**
 * @param {Buffer} other_public_key
 * @return {Buffer}
 */
crypto.DiffieHellman.prototype.computeSecret = function(other_public_key) {};

/**
 * @param {string} other_public_key
 * @param {(string)} input_encoding
 * @return {Buffer}
 */
crypto.DiffieHellman.prototype.computeSecret = function(other_public_key, input_encoding) {};

/**
 * @param {string} other_public_key
 * @param {(string)} input_encoding
 * @param {(string)} output_encoding
 * @return {string}
 */
crypto.DiffieHellman.prototype.computeSecret = function(other_public_key, input_encoding, output_encoding) {};

/**
 * @return {Buffer}
 */
crypto.DiffieHellman.prototype.getPrime = function() {};

/**
 * @param {(string)} encoding
 * @return {string}
 */
crypto.DiffieHellman.prototype.getPrime = function(encoding) {};

/**
 * @return {Buffer}
 */
crypto.DiffieHellman.prototype.getGenerator = function() {};

/**
 * @param {(string)} encoding
 * @return {string}
 */
crypto.DiffieHellman.prototype.getGenerator = function(encoding) {};

/**
 * @return {Buffer}
 */
crypto.DiffieHellman.prototype.getPublicKey = function() {};

/**
 * @param {(string)} encoding
 * @return {string}
 */
crypto.DiffieHellman.prototype.getPublicKey = function(encoding) {};

/**
 * @return {Buffer}
 */
crypto.DiffieHellman.prototype.getPrivateKey = function() {};

/**
 * @param {(string)} encoding
 * @return {string}
 */
crypto.DiffieHellman.prototype.getPrivateKey = function(encoding) {};

/**
 * @param {Buffer} public_key
 * @return {void}
 */
crypto.DiffieHellman.prototype.setPublicKey = function(public_key) {};

/**
 * @param {string} public_key
 * @param {string} encoding
 * @return {void}
 */
crypto.DiffieHellman.prototype.setPublicKey = function(public_key, encoding) {};

/**
 * @param {Buffer} private_key
 * @return {void}
 */
crypto.DiffieHellman.prototype.setPrivateKey = function(private_key) {};

/**
 * @param {string} private_key
 * @param {string} encoding
 * @return {void}
 */
crypto.DiffieHellman.prototype.setPrivateKey = function(private_key, encoding) {};

/**
 * @type {number}
 */
crypto.DiffieHellman.prototype.verifyError;

/**
 * @param {string} group_name
 * @return {crypto.DiffieHellman}
 */
crypto.getDiffieHellman = function(group_name) {};

/**
 * @param {(string|Buffer)} password
 * @param {(string|Buffer)} salt
 * @param {number} iterations
 * @param {number} keylen
 * @param {string} digest
 * @param {(function(Error, Buffer): *)} callback
 * @return {void}
 */
crypto.pbkdf2 = function(password, salt, iterations, keylen, digest, callback) {};

/**
 * @param {(string|Buffer)} password
 * @param {(string|Buffer)} salt
 * @param {number} iterations
 * @param {number} keylen
 * @param {string} digest
 * @return {Buffer}
 */
crypto.pbkdf2Sync = function(password, salt, iterations, keylen, digest) {};

/**
 * @param {number} size
 * @return {Buffer}
 */
crypto.randomBytes = function(size) {};

/**
 * @param {number} size
 * @param {(function(Error, Buffer): void)} callback
 * @return {void}
 */
crypto.randomBytes = function(size, callback) {};

/**
 * @param {number} size
 * @return {Buffer}
 */
crypto.pseudoRandomBytes = function(size) {};

/**
 * @param {number} size
 * @param {(function(Error, Buffer): void)} callback
 * @return {void}
 */
crypto.pseudoRandomBytes = function(size, callback) {};

/**
 * @interface
 */
crypto.RsaPublicKey = function() {};

/**
 * @type {string}
 */
crypto.RsaPublicKey.prototype.key;

/**
 * @type {number}
 */
crypto.RsaPublicKey.prototype.padding;

/**
 * @interface
 */
crypto.RsaPrivateKey = function() {};

/**
 * @type {string}
 */
crypto.RsaPrivateKey.prototype.key;

/**
 * @type {string}
 */
crypto.RsaPrivateKey.prototype.passphrase;

/**
 * @type {number}
 */
crypto.RsaPrivateKey.prototype.padding;

/**
 * @param {(string|crypto.RsaPublicKey)} public_key
 * @param {Buffer} buffer
 * @return {Buffer}
 */
crypto.publicEncrypt = function(public_key, buffer) {};

/**
 * @param {(string|crypto.RsaPrivateKey)} private_key
 * @param {Buffer} buffer
 * @return {Buffer}
 */
crypto.privateDecrypt = function(private_key, buffer) {};

/**
 * @param {(string|crypto.RsaPrivateKey)} private_key
 * @param {Buffer} buffer
 * @return {Buffer}
 */
crypto.privateEncrypt = function(private_key, buffer) {};

/**
 * @param {(string|crypto.RsaPublicKey)} public_key
 * @param {Buffer} buffer
 * @return {Buffer}
 */
crypto.publicDecrypt = function(public_key, buffer) {};

/**
 * @return {Array<string>}
 */
crypto.getCiphers = function() {};

/**
 * @return {Array<string>}
 */
crypto.getCurves = function() {};

/**
 * @return {Array<string>}
 */
crypto.getHashes = function() {};

/**
 * @interface
 */
crypto.ECDH = function() {};

/**
 * @return {Buffer}
 */
crypto.ECDH.prototype.generateKeys = function() {};

/**
 * @param {(string)} encoding
 * @return {string}
 */
crypto.ECDH.prototype.generateKeys = function(encoding) {};

/**
 * @param {(string)} encoding
 * @param {(string)} format
 * @return {string}
 */
crypto.ECDH.prototype.generateKeys = function(encoding, format) {};

/**
 * @param {Buffer} other_public_key
 * @return {Buffer}
 */
crypto.ECDH.prototype.computeSecret = function(other_public_key) {};

/**
 * @param {string} other_public_key
 * @param {(string)} input_encoding
 * @return {Buffer}
 */
crypto.ECDH.prototype.computeSecret = function(other_public_key, input_encoding) {};

/**
 * @param {string} other_public_key
 * @param {(string)} input_encoding
 * @param {(string)} output_encoding
 * @return {string}
 */
crypto.ECDH.prototype.computeSecret = function(other_public_key, input_encoding, output_encoding) {};

/**
 * @return {Buffer}
 */
crypto.ECDH.prototype.getPrivateKey = function() {};

/**
 * @param {(string)} encoding
 * @return {string}
 */
crypto.ECDH.prototype.getPrivateKey = function(encoding) {};

/**
 * @return {Buffer}
 */
crypto.ECDH.prototype.getPublicKey = function() {};

/**
 * @param {(string)} encoding
 * @return {string}
 */
crypto.ECDH.prototype.getPublicKey = function(encoding) {};

/**
 * @param {(string)} encoding
 * @param {(string)} format
 * @return {string}
 */
crypto.ECDH.prototype.getPublicKey = function(encoding, format) {};

/**
 * @param {Buffer} private_key
 * @return {void}
 */
crypto.ECDH.prototype.setPrivateKey = function(private_key) {};

/**
 * @param {string} private_key
 * @param {(string)} encoding
 * @return {void}
 */
crypto.ECDH.prototype.setPrivateKey = function(private_key, encoding) {};

/**
 * @param {string} curve_name
 * @return {crypto.ECDH}
 */
crypto.createECDH = function(curve_name) {};

/**
 * @type {string}
 */
crypto.DEFAULT_ENCODING;

module.exports.Certificate = crypto.Certificate;

module.exports.Certificate = crypto.Certificate;

module.exports.fips = crypto.fips;

module.exports.CredentialDetails = crypto.CredentialDetails;

module.exports.Credentials = crypto.Credentials;

module.exports.createCredentials = crypto.createCredentials;

module.exports.createHash = crypto.createHash;

module.exports.createHmac = crypto.createHmac;

module.exports.Hash = crypto.Hash;

module.exports.Hmac = crypto.Hmac;

module.exports.createCipher = crypto.createCipher;

module.exports.createCipheriv = crypto.createCipheriv;

module.exports.Cipher = crypto.Cipher;

module.exports.createDecipher = crypto.createDecipher;

module.exports.createDecipheriv = crypto.createDecipheriv;

module.exports.Decipher = crypto.Decipher;

module.exports.createSign = crypto.createSign;

module.exports.Signer = crypto.Signer;

module.exports.createVerify = crypto.createVerify;

module.exports.Verify = crypto.Verify;

module.exports.createDiffieHellman = crypto.createDiffieHellman;

module.exports.createDiffieHellman = crypto.createDiffieHellman;

module.exports.createDiffieHellman = crypto.createDiffieHellman;

module.exports.createDiffieHellman = crypto.createDiffieHellman;

module.exports.createDiffieHellman = crypto.createDiffieHellman;

module.exports.DiffieHellman = crypto.DiffieHellman;

module.exports.getDiffieHellman = crypto.getDiffieHellman;

module.exports.pbkdf2 = crypto.pbkdf2;

module.exports.pbkdf2Sync = crypto.pbkdf2Sync;

module.exports.randomBytes = crypto.randomBytes;

module.exports.randomBytes = crypto.randomBytes;

module.exports.pseudoRandomBytes = crypto.pseudoRandomBytes;

module.exports.pseudoRandomBytes = crypto.pseudoRandomBytes;

module.exports.RsaPublicKey = crypto.RsaPublicKey;

module.exports.RsaPrivateKey = crypto.RsaPrivateKey;

module.exports.publicEncrypt = crypto.publicEncrypt;

module.exports.privateDecrypt = crypto.privateDecrypt;

module.exports.privateEncrypt = crypto.privateEncrypt;

module.exports.publicDecrypt = crypto.publicDecrypt;

module.exports.getCiphers = crypto.getCiphers;

module.exports.getCurves = crypto.getCurves;

module.exports.getHashes = crypto.getHashes;

module.exports.ECDH = crypto.ECDH;

module.exports.createECDH = crypto.createECDH;

module.exports.DEFAULT_ENCODING = crypto.DEFAULT_ENCODING;

/**
 * @interface
 * @extends {crypto.Signer}
 */
crypto.Sign = function() {};

/**
 * @param {number} size
 * @param {(function(Error, Buffer): *)=} callback
 * @return {void}
 */
crypto.rng = function(size, callback) {};

/**
 * @param {number} size
 * @param {(function(Error, Buffer): *)=} callback
 * @return {void}
 */
crypto.prng = function(size, callback) {};

/**
 * @interface
 * @extends {NodeJS.ReadWriteStream}
 */
crypto.Decipher = function() {};

/**
 * @param {string} output_encoding
 * @return {(string|Buffer)}
 */
crypto.Decipher.prototype.finaltol = function(output_encoding) {};

/**
 * @interface
 */
crypto.ECDH = function() {};

/**
 * @param {Buffer} private_key
 * @return {void}
 */
crypto.ECDH.prototype.setPublicKey = function(private_key) {};

/**
 * @param {string} private_key
 * @param {string} encoding
 * @return {void}
 */
crypto.ECDH.prototype.setPublicKey = function(private_key, encoding) {};

module.exports.Sign = crypto.Sign;

module.exports.rng = crypto.rng;

module.exports.prng = crypto.prng;

module.exports.Decipher = crypto.Decipher;

module.exports.ECDH = crypto.ECDH;

