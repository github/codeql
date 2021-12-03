var session = require("cookie-session");

session({
    secret: "secret-key-1"
});

session({
    keys: ["secret-key-2", "secret-key-3"]
});
