const crypto = require('crypto');

var secretText = trusted; // sensitive according to SensitiveActions.qll

const desCipher = crypto.createCipher('des', key);
const aesCipher = crypto.createCipher('aes-128', key);
const unknownCipher = crypto.createCipher('unknown', key);

desCipher.write(publicInfo, 'utf8', 'hex'); // OK: not secret information

desCipher.write(secretText, 'utf8', 'hex'); // BAD

aesCipher.update(secretText, 'utf8', 'hex'); // GOOD

unknownCipher.update(secretText, 'utf8', 'hex'); // OK: unknown algorithm

desCipher.write(o.trusted, 'utf8', 'hex'); // BAD

desCipher.write(password, 'utf8', 'hex'); // OK (flagged by js/insufficient-password-hash)

const aesEcbCipher = crypto.createCipher('aes-128-ecb', key);
aesEcbCipher.update(secretText, 'utf8', 'hex'); // BAD
