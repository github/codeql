function hashPassword(password) {
    var crypto = require("crypto");
    var hasher = crypto.createHash('md5');
    var hashed = hasher.update(password).digest("hex"); // BAD
    return hashed;
}
