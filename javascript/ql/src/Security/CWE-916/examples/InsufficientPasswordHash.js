const crypto = require("crypto");
function hashPassword(password) {
    var hasher = crypto.createHash('md5');
    var hashed = hasher.update(password).digest("hex"); // BAD
    return hashed;
}
