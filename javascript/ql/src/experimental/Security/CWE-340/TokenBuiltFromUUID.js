var uuid = require('uuid');

module.exports = function (app) {

    app.use('/login', function (req, res) {

        var username = req.body.username;
        var password = req.body.password;

        if (!username) {
            res.status(400);
            return;
        }

        if (!password) {
            res.status(400);
            return;
        }

        var newToken = {
            userId: user._id,
            token: uuid.v1(),
            created: new Date(),
        };

        res.status(200).json({
            token: newToken.token
        });
    });
};