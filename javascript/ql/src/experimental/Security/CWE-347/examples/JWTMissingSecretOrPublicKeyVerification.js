const jwt = require("jsonwebtoken");

const secret = "buybtc";
// #1
var token = jwt.sign({ foo: 'bar' }, secret, { algorithm: "HS256" }) // alg:HS256
jwt.verify(token, secret, { algorithms: ["HS256", "none"] }) // pass
// #2
var token = jwt.sign({ foo: 'bar' }, secret, { algorithm: "none" }) // alg:none (unsafe)
jwt.verify(token, "", { algorithms: ["HS256", "none"] }) // detected
jwt.verify(token, undefined, { algorithms: ["HS256", "none"] }) // detected
jwt.verify(token, false, { algorithms: ["HS256", "none"] }) // detected