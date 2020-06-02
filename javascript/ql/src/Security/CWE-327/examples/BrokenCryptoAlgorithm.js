const crypto = require('crypto');

var secretText = obj.getSecretText();

const desCipher = crypto.createCipher('des', key);
let desEncrypted = desCipher.write(secretText, 'utf8', 'hex'); // BAD: weak encryption

const aesCipher = crypto.createCipher('aes-128', key);
let aesEncrypted = aesCipher.update(secretText, 'utf8', 'hex'); // GOOD: strong encryption
