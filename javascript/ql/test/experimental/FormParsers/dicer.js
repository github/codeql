const { inspect } = require('util');
const http = require('http');
const Dicer = require('dicer');
const sink = require('sink');

const PORT = 8080;

http.createServer((req, res) => {
    let m;
    const dicer = new Dicer({ boundary: m[1] || m[2] });

    dicer.on('part', (part) => {
        part.pipe(sink())
        part.on('header', (header) => {
            for (h in header) {
                sink(header[h])
            }
        });
        part.on('data', (data) => {
            sink(data)
        });
    });
}).listen(PORT, () => {
    console.log(`Listening for requests on port ${PORT}`);
});