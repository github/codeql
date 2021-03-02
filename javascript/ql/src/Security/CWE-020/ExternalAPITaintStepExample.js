let path = require('path');

express().get('/data', (req, res) => {
    let file = path.join(HOME_DIR, 'public', req.query.file);
    res.sendFile(file);
});
