const express = require('express');
const rimraf = require('rimraf');

const app = express();
app.use(express.json());

app.post('/rmsync', async (req, res) => {
    const { path } = req.body; // $ Source

    rimraf.sync(path); // $ Alert
    rimraf.rimrafSync(path); // $ Alert
    rimraf.native(path); // $ Alert
    await rimraf.native(path); // $ Alert
    rimraf.native.sync(path); // $ Alert
    rimraf.nativeSync(path); // $ Alert
    await rimraf.manual(path); // $ Alert
    rimraf.manual(path); // $ Alert
    rimraf.manual.sync(path); // $ Alert
    rimraf.manualSync(path); // $ Alert
    await rimraf.windows(path); // $ Alert
    rimraf.windows(path); // $ Alert
    rimraf.windows.sync(path); // $ Alert
    rimraf.windowsSync(path); // $ Alert
    rimraf.moveRemove(path); // $ Alert
    rimraf.moveRemove.sync(path); // $ Alert
    rimraf.moveRemoveSync(path); // $ Alert
    rimraf.posixSync(path); // $ Alert
    rimraf.posix(path); // $ Alert
    rimraf.posix.sync(path); // $ Alert
});
