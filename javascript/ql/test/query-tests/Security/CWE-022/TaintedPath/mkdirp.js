const express = require('express');
const mkdirp = require('mkdirp');
const path = require('path');

const app = express();
app.use(express.json());

app.post('/foo', async (req, res) => {
    const dirPath = path.join(__dirname, req.query.filename || 'defaultDir'); // $ Source

    mkdirp(dirPath); // $ Alert
    mkdirp.sync(dirPath); // $ Alert
    mkdirp.nativeSync(dirPath); // $ MISSING: Alert
    mkdirp.native(dirPath); // $ MISSING: Alert
    mkdirp.manual(dirPath); // $ MISSING: Alert
    mkdirp.manualSync(dirPath); // $ MISSING: Alert
    mkdirp.mkdirpNative(dirPath); // $ MISSING: Alert
    mkdirp.mkdirpManual(dirPath); // $ MISSING: Alert
    mkdirp.mkdirpManualSync(dirPath); // $ MISSING: Alert
    mkdirp.mkdirpNativeSync(dirPath); // $ MISSING: Alert
    mkdirp.mkdirpSync(dirPath); // $ MISSING: Alert
});
