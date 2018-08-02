function hashPassword(password, salt) {
    var bcrypt = require('bcrypt');
    var hashed = bcrypt.hashSync(password, salt); // GOOD
    return hashed;
}
