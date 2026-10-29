const express = require('express');
const mkdirp = require('mkdirp');
const path = require('path');

const app = express();
app.use(express.json());

app.post('/foo', async (req, res) => {
    const dirPath = path.join(__dirname, req.query.filename || 'defaultDir'); // $ Source

    mkdirp(dirPath); // $ Alert
    mkdirp.sync(dirPath); // $ Alert
    mkdirp.nativeSync(dirPath); // $ Alert
    mkdirp.native(dirPath); // $ Alert
    mkdirp.manual(dirPath); // $ Alert
    mkdirp.manualSync(dirPath); // $ Alert
    mkdirp.mkdirpNative(dirPath); // $ Alert
    mkdirp.mkdirpManual(dirPath); // $ Alert
    mkdirp.mkdirpManualSync(dirPath); // $ Alert
    mkdirp.mkdirpNativeSync(dirPath); // $ Alert
    mkdirp.mkdirpSync(dirPath); // $ Alert
});
