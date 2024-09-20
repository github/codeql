const unzipper = require("unzipper");
const express = require('express')
const fileUpload = require("express-fileupload");
const { Readable } = require('stream');
const { createWriteStream, readFileSync } = require("fs");
const stream = require("node:stream");
const app = express();
app.use(fileUpload());
app.listen(3000, () => {
});

app.post('/upload', async (req, res) => {
    const RemoteStream = Readable.from(req.files.ZipFile.data);

    // Unsafe
    RemoteStream.pipe(unzipper.Extract({ path: 'output/path' }));

    // Unsafe
    RemoteStream.pipe(unzipper.ParseOne())
        .pipe(createWriteStream('firstFile.txt'));

    // Safe because of uncompressedSize
    RemoteStream
        .pipe(unzipper.Parse())
        .on('entry', function (entry) {
            const size = entry.vars.uncompressedSize;
            if (size < 1024 * 1024 * 1024) {
                entry.pipe(createWriteStream('output/path'));
            }
        });

    // Unsafe
    RemoteStream
        .pipe(unzipper.Parse())
        .on('entry', function (entry) {
            const size = entry.vars.uncompressedSize;
            entry.pipe(createWriteStream('output/path'));
        });

    // Unsafe
    const zip = RemoteStream.pipe(unzipper.Parse({ forceStream: true }));
    for await (const entry of zip) {
        const fileName = entry.path;
        if (fileName === "this IS the file I'm looking for") {
            entry.pipe(createWriteStream('output/path'));
        } else {
            entry.autodrain();
        }
    }
    // Safe
    const zip2 = RemoteStream.pipe(unzipper.Parse({ forceStream: true }));
    for await (const entry of zip2) {
        const size = entry.vars.uncompressedSize;
        if (size < 1024 * 1024 * 1024) {
            entry.pipe(createWriteStream('output/path'));
        }
    }

    // Safe  because of uncompressedSize
    RemoteStream.pipe(unzipper.Parse())
        .pipe(stream.Transform({
            objectMode: true,
            transform: function (entry, e, cb) {
                const size = entry.vars.uncompressedSize; // There is also compressedSize;
                if (size < 1024 * 1024 * 1024) {
                    entry.pipe(createWriteStream('output/path'))
                        .on('finish', cb);
                }
            }
        }));

    // Unsafe
    RemoteStream.pipe(unzipper.Parse())
        .pipe(stream.Transform({
            objectMode: true,
            transform: function (entry, e, cb) {
                entry.pipe(createWriteStream('output/path'))
                    .on('finish', cb);
            }
        }));

    let directory = await unzipper.Open.file('path/to/archive.zip');
    new Promise((resolve, reject) => {
        directory.files[0]
            .stream()
            .pipe(fs.createWriteStream('firstFile'))
            .on('error', reject)
            .on('finish', resolve)
    });

    const request = require('request');
    // Unsafe
    directory = await unzipper.Open.url(request, 'http://example.com/example.zip');
    const file = directory.files.find(d => d.path === 'example.xml');
    await file.buffer();

    // Unsafe
    const buffer = readFileSync(request.query.FilePath);
    directory = await unzipper.Open.buffer(buffer);
    directory.files[0].buffer();

    // Unsafe
    unzipper.Open.file(request.query.FilePath)
        .then(d => d.extract({ path: '/extraction/path', concurrency: 5 }));

});
