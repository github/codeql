password; // $ cleartextPasswordExpr sensitiveExpr=password
PassWord; // $ cleartextPasswordExpr sensitiveExpr=password
myPasswordInCleartext; // $ cleartextPasswordExpr sensitiveExpr=password
x.password; // $ cleartextPasswordExpr sensitiveExpr=password
getPassword(); // $ cleartextPasswordExpr sensitiveExpr=password
x.getPassword(); // $ cleartextPasswordExpr sensitiveExpr=password
get("password"); // $ cleartextPasswordExpr sensitiveExpr=password
x.get("password"); // $ cleartextPasswordExpr sensitiveExpr=password

hashed_password;
password_hashed;
password_hash;
hash_password;
hashedPassword;

var exit = require('exit');
var e = process.exit;
e(); // $ processTermination sensitiveAction
exit(); // $ processTermination sensitiveAction

secret; // $ sensitiveExpr=secret

require("process").exit(); // $ processTermination sensitiveAction
global.process.exit(); // $ processTermination sensitiveAction

get("https://example.com/news?password=true")
get("https://username:password@example.com")
execute("SELECT * FROM users WHERE password=?")
