const express = require('express');
const app = express();
app.use(require('body-parser').urlencoded({ extended: false }))

// bad: sensitive information is read from query parameters
app.get('/login1', (req, res) => {
    const user = req.query.user;
    const password = req.query.password;
    if (checkUser(user, password)) {
        res.send('Welcome');
    } else {
        res.send('Access denied');
    }
});

// good: sensitive information is read from post body
app.post('/login2', (req, res) => {
    const user = req.body.user;
    const password = req.body.password;
    if (checkUser(user, password)) {
        res.send('Welcome');
    } else {
        res.send('Access denied');
    }
});
