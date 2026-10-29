import { makeDirectory, makeDirectorySync } from 'make-dir';

const express = require('express');
const app = express();

app.get('/makedir', async (req, res) => {
    const file = req.query.file; // $ Source

    await makeDirectory(file); // $ Alert
    makeDirectorySync(file); // $ Alert
});
