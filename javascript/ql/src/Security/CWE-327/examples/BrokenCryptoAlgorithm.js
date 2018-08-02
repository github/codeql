const crypto = require('crypto');

const desCipher = crypto.createCipher('des', key);
let desEncrypted = cipher.write(secretText, 'utf8', 'hex'); // BAD: weak encryption

const aesCipher = crypto.createCipher('aes-128', key);
let aesEncrypted = cipher.update(secretText, 'utf8', 'hex'); // GOOD: strong encryption
