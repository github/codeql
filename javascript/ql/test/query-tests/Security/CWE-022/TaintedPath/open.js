import open, {openApp, apps} from 'open';

const express = require('express');
const app = express();

app.get('/open', (req, res) => {
    const file = req.query.file; // $ MISSING: Source

    open(file); // $ MISSING: Alert
    openApp(file); // $ MISSING: Alert
});
