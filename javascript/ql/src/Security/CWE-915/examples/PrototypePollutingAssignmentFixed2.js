let express = require('express');
let app = express()

app.put('/todos/:id', (req, res) => {
    let id = req.params.id;
    if (id === '__proto__' || id === 'constructor' || id === 'prototype') {
        res.end(403);
        return;
    }
    let items = req.session.todos[id];
    if (!items) {
        items = req.session.todos[id] = {};
    }
    items[req.query.name] = req.query.text;
    res.end(200);
});
