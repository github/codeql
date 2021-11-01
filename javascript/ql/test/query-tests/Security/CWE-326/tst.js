const crypto = require("crypto");

const bad1 = crypto.generateKeyPairSync("rsa", { modulusLength: 1024 }); // NOT OK

const good1 = crypto.generateKeyPairSync("rsa", { modulusLength: 4096 }); // OK

const bad2 = crypto.generateKeySync("hmac", { length: 64 }); // NOT OK

const good2 = crypto.generateKeySync("aes", { length: 256 }); // OK