const jwt = require("jsonwebtoken");

const secret = "my-secret-key";

var token = jwt.sign({ foo: 'bar' }, secret, { algorithm: "none" })
jwt.verify(token, false, { algorithms: ["HS256", "none"] })