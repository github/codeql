const jwt = require("jsonwebtoken");

const secret = "my-secret-key";

var token = jwt.sign({ foo: 'bar' }, secret, { algorithm: "HS256" }) 
jwt.verify(token, secret, { algorithms: ["HS256", "none"] }) // OK


var token = jwt.sign({ foo: 'bar' }, secret, { algorithm: "none" })
jwt.verify(token, "", { algorithms: ["HS256", "none"] }) // NOT OK
jwt.verify(token, undefined, { algorithms: ["HS256", "none"] }) // NOT OK
jwt.verify(token, false, { algorithms: ["HS256", "none"] }) // NOT OK