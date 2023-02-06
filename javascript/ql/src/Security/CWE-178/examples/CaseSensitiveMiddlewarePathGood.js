const app = require('express')();

app.use(/\/admin\/.*/i, (req, res, next) => {
    if (!req.user.isAdmin) {
        res.status(401).send('Unauthorized');
    } else {
        next();
    }
});

app.get('/admin/users/:id', (req, res) => {
    res.send(app.database.users[req.params.id]);
});
