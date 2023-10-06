const http = require('http');
const zlib = require('node:zlib');
const busboy = require('busboy');
const sink = require('sink');

http.createServer((req, res) => {
    if (req.method === 'POST') {
        const bb = busboy({ headers: req.headers });
        bb.on('file', (name, file, info) => {
            const { filename, encoding, mimeType } = info;
            const z = zlib.createGzip();
            sink(filename, encoding, mimeType) // sink
            file.pipe(z).pipe(sink())

            file.on('data', (data) => {
                sink(data)
            })

            file.on('readable', function () {
                // There is some data to read now.
                let data;
                while ((data = this.read()) !== null) {
                    sink(data)
                }
            });
        });
        bb.on('field', (name, val, info) => {
            sink(name, val, info)
        });
    }
}).listen(8000, () => {
    console.log('Listening for requests');
});