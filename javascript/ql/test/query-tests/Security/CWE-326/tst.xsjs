const crypto = $.require("crypto");

const bad1 = crypto.generateKeyPairSync("rsa", { modulusLength: 1024 }); // $ Alert

const good1 = crypto.generateKeyPairSync("rsa", { modulusLength: 4096 }); // OK
