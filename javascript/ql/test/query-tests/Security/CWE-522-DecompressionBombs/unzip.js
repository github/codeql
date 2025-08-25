const unzip = require("unzip");
const { createWriteStream } = require("fs");
const express = require('express')
const fileUpload = require("express-fileupload");
const { Readable } = require("stream");

const app = express();
app.use(fileUpload());
app.listen(3000, () => {
});

app.post('/upload', async (req, res) => {
    const InputStream = Readable.from(req.files.ZipFile.data);
    InputStream.pipe(unzip.Parse())
        .on('entry', function (entry) {
            if (entry.uncompressedSize > 1024) {
                throw "uncompressed size exceed"
            }
        });


    let writeStream = createWriteStream('output/path');
    InputStream
        .pipe(unzip.Parse())
        .pipe(writeStream)
});