let express = require('express');

express.put('/todos/:id', (req, res) => {
    let id = req.params.id;
    let items = req.session.todos.get(id);
    if (!items) {
        items = new Map();
        req.sessions.todos.set(id, items);
    }
    items.set(req.query.name, req.query.text);
    res.end(200);
});
