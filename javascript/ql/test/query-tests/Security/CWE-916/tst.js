var password = "secret";

require("bcrypt").hash(password); // OK

require('crypto').createCipher('aes192').write(password); // NOT OK

require('crypto').createHash('sha256').write(password); // NOT OK

require('crypto').createHash('md5').write(password); // NOT OK
