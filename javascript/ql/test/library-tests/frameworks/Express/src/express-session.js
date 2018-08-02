var session = require("express-session");

session({
    secret: "secret-key-1"
});

session({
    secret: ["secret-key-2", "secret-key-3"]
});
