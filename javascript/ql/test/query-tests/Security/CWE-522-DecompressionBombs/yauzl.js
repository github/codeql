const { pipeline } = require('stream/promises');
const yauzl = require("yauzl");
const fs = require("fs");
const express = require('express')
const fileUpload = require("express-fileupload");
const app = express();
app.use(fileUpload());
app.listen(3000, () => {
});

app.post('/upload', (req, res) => {
    yauzl.fromFd(req.files.zipFile.data)
    yauzl.fromBuffer(req.files.zipFile.data)
    yauzl.fromRandomAccessReader(req.files.zipFile.data)
    // Safe
    yauzl.open(req.query.filePath, { lazyEntries: true }, function (err, zipfile) {
        if (err) throw err;
        zipfile.readEntry();
        zipfile.on("entry", function (entry) {
            zipfile.openReadStream(entry, async function (err, readStream) {
                if (err) throw err;
                if (entry.uncompressedSize > 1024 * 1024 * 1024) {
                    throw err
                }
                readStream.on("end", function () {
                    zipfile.readEntry();
                });
                const outputFile = fs.createWriteStream('testiness');
                await pipeline(
                    readStream,
                    outputFile
                )
            });
        });
    });
    // Unsafe
    yauzl.open(req.query.filePath, { lazyEntries: true }, function (err, zipfile) {
        if (err) throw err;
        zipfile.readEntry();
        zipfile.on("entry", function (entry) {
            zipfile.openReadStream(entry, async function (err, readStream) {
                readStream.on("end", function () {
                    zipfile.readEntry();
                });
                const outputFile = fs.createWriteStream('testiness');
                await pipeline(
                    readStream,
                    outputFile
                )
            });
        });
    });
    res.send("OK")
});