const tar = require("tar");
const express = require('express')
const fileUpload = require("express-fileupload");
const { Readable, writeFileSync } = require("stream");
const fs = require("fs");
const { createGunzip } = require("zlib");
const app = express();
const port = 3000;
app.use(fileUpload());
app.listen(port, () => {
    console.log(`Example app listening on port ${port}`)
});

app.post('/upload', (req, res) => {
    zipBomb(req.files.zipBombFile.data)
    res.send('Hello World!')
});

function zipBomb(tarFile) {
    // scenario 1
    const inputFile = Readable.from(tarFile.data);
    const outputFile = fs.createWriteStream('/tmp/untar');
    inputFile.pipe(
        tar.x()
    ).pipe(outputFile);

    // scenario 2
    fs.writeFileSync(tarFile.name, tarFile.data);
    fs.createReadStream(tarFile.name).pipe(
        tar.x({
            strip: 1,
            C: 'some-dir'
        })
    )
    // safe https://github.com/isaacs/node-tar/blob/8c5af15e43a769fd24aa7f1c84d93e54824d19d2/lib/list.js#L90
    fs.createReadStream(tarFile.name).pipe(
        tar.x({
            strip: 1,
            C: 'some-dir',
            maxReadSize: 16 * 1024 * 1024 // 16 MB
        })
    )
    // scenario 3
    const decompressor = createGunzip();
    fs.createReadStream(tarFile.name).pipe(
        decompressor
    ).pipe(
        tar.x({
            cwd: "dest"
        })
    )

    // scenario 4
    fs.writeFileSync(tarFile.name, tarFile.data);
    // or using fs.writeFile
    // file path is a tmp file name that can get from DB after saving to DB with remote file upload
    // so the input file name will come from a DB source
    tar.x({ file: tarFile.name })
    tar.extract({ file: tarFile.name })
    // safe https://github.com/isaacs/node-tar/blob/8c5af15e43a769fd24aa7f1c84d93e54824d19d2/lib/list.js#L90
    tar.x({
        file: tarFile.name,
        strip: 1,
        C: 'some-dir',
        maxReadSize: 16 * 1024 * 1024 // 16 MB
    })
}