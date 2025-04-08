const express = require('express');
const fs = require('fs-extra');
const app = express();

app.use(express.json());

app.post('/rmsync', (req, res) => {
    const { filename } = req.body; // $ Source
    
    fs.rmSync(filename); // $ Alert
    fs.rm(filename); // $ Alert
    fs.rmdir(filename); // $ Alert
    fs.rmdirSync(filename); // $ Alert
    fs.cp(filename, "destination"); // $ Alert
    fs.cp("source", filename); // $ Alert
    fs.copyFileSync(filename, "destination"); // $ Alert
    fs.copyFileSync("source", filename); // $ Alert
    fs.cpSync(filename, "destination"); // $ Alert
    fs.cpSync("source", filename); // $ Alert
    fs.emptydirSync(filename); // $ Alert
    fs.emptydir(filename); // $ Alert
    fs.opendir(filename); // $ Alert
    fs.opendirSync(filename); // $ Alert
    fs.openAsBlob(filename); // $ Alert
    fs.statfs(filename); // $ Alert
    fs.statfsSync(filename); // $ Alert
    fs.open(filename, 'r'); // $ Alert
    fs.openSync(filename, 'r'); // $ Alert
    fs.outputJSONSync(filename, req.body.data, { spaces: 2 }); // $ Alert
    fs.lutimes(filename, new Date(req.body.atime), new Date(req.body.mtime)); // $ Alert
    fs.lutimesSync(filename, new Date(req.body.atime), new Date(req.body.mtime)); // $ Alert
    fs.outputJsonSync(filename, { timestamp: new Date().toISOString(), action: req.body.action, user: req.body.user}, { spaces: 2 }); // $ Alert
});
