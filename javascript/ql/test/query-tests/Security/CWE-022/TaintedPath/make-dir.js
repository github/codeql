import { makeDirectory, makeDirectorySync } from 'make-dir';

const express = require('express');
const app = express();

app.get('/makedir', (req, res) => {
    const file = req.query.file; // $ Source

    makeDirectory(file); // $ Alert
    makeDirectorySync(file); // $ Alert
});
