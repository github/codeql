const expressjwt = require("express-jwt");
var {getSecret} = require('./Config.js');
app.get(
    "/protected",
    expressjwt.expressjwt({secret: getSecret(), algorithms: ["HS256"]}),
    function (req, res) {
        if (!req.auth.admin) return res.sendStatus(401);
        res.sendStatus(200);
    }
);
expressjwt.expressjwt({
    secret: Buffer.from(getSecret(), "base64"),
    algorithms: ["RS256"],
});
