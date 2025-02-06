var password = "secret";

require("bcrypt").hash(password);

require('crypto').createCipher('aes192').write(password); // $ Alert

require('crypto').createHash('sha256').write(password); // $ Alert

require('crypto').createHash('md5').write(password); // $ Alert
