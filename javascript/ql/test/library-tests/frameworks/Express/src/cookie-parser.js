var session = require("cookie-parser");

session("secret-key-1");

session(["secret-key-2", "secret-key-3"]);
