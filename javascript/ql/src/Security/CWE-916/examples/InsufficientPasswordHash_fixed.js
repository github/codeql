const bcrypt = require("bcrypt");
function hashPassword(password, salt) {
  var hashed = bcrypt.hashSync(password, salt); // GOOD
  return hashed;
}
