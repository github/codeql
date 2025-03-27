const express = require('express');
const fs = require('fs-extra');
const app = express();

app.use(express.json());

app.post('/rmsync', (req, res) => {
    const { filename } = req.body; // $ MISSING: Source
    
    fs.rmSync(filename); // MISSING: $ Alert
    fs.rm(filename); // MISSING: $ Alert
    fs.rmdir(filename); // MISSING: $ Alert
    fs.rmdirSync(filename); // MISSING: $ Alert
    fs.cp(filename, "destination"); // MISSING: $ Alert
    fs.cp("source", filename); // MISSING: $ Alert
    fs.copyFileSync(filename, "destination"); // MISSING: $ Alert
    fs.copyFileSync("source", filename); // MISSING: $ Alert
    fs.cpSync(filename, "destination"); // MISSING: $ Alert
    fs.cpSync("source", filename); // MISSING: $ Alert
    fs.emptydirSync(filename); // MISSING: $ Alert
    fs.emptydir(filename); // MISSING: $ Alert
    fs.opendir(filename); // $ MISSING: Alert
    fs.opendirSync(filename); // $ MISSING: Alert
    fs.openAsBlob(filename); // $ MISSING: Alert
    fs.statfs(filename); // $ MISSING: Alert
    fs.statfsSync(filename); // $ MISSING: Alert
    fs.open(filename, 'r'); // $ MISSING: Alert
    fs.openSync(filename, 'r'); // $ MISSING: Alert
    fs.outputJSONSync(filename, req.body.data, { spaces: 2 }); // $ MISSING: Alert
    fs.lutimes(filename, new Date(req.body.atime), new Date(req.body.mtime)); // MISSING: $ Alert
    fs.lutimesSync(filename, new Date(req.body.atime), new Date(req.body.mtime)); // MISSING: $ Alert
    fs.outputJsonSync(filename, { timestamp: new Date().toISOString(), action: req.body.action, user: req.body.user}, { spaces: 2 }); // $ MISSING: Alert
});
