import open, {openApp, apps} from 'open';

const express = require('express');
const app = express();

app.get('/open', (req, res) => {
    const file = req.query.file; // $ Source

    open(file); // $ Alert
    openApp(file); // $ Alert
});
