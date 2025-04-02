const express = require('express');
const rimraf = require('rimraf');

const app = express();
app.use(express.json());

app.post('/rmsync', async (req, res) => {
    const { path } = req.body; // $ MISSING: Source

    rimraf.sync(path); // $ MISSING: Alert
    rimraf.rimrafSync(path); // $ MISSING: Alert
    rimraf.native(path); // $ MISSING: Alert
    await rimraf.native(path); // $ MISSING: Alert
    rimraf.native.sync(path); // $ MISSING: Alert
    rimraf.nativeSync(path); // $ MISSING: Alert
    await rimraf.manual(path); // $ MISSING: Alert
    rimraf.manual(path); // $ MISSING: Alert
    rimraf.manual.sync(path); // $ MISSING: Alert
    rimraf.manualSync(path); // $ MISSING: Alert
    await rimraf.windows(path); // $ MISSING: Alert
    rimraf.windows(path); // $ MISSING: Alert
    rimraf.windows.sync(path); // $ MISSING: Alert
    rimraf.windowsSync(path); // $ MISSING: Alert
    rimraf.moveRemove(path); // $ MISSING: Alert
    rimraf.moveRemove.sync(path); // $ MISSING: Alert
    rimraf.moveRemoveSync(path); // $ MISSING: Alert
    rimraf.posixSync(path); // $ MISSING: Alert
    rimraf.posix(path); // $ MISSING: Alert
    rimraf.posix.sync(path); // $ MISSING: Alert
});
