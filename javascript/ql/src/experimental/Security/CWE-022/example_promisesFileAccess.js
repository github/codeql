import fsPromises from "fs/promises";
import fs from 'node:fs';
import { Buffer } from 'node:buffer';
import zlib from "zlib";

const buf = Buffer.alloc(5);
await fs.promises.open('/dev/input/event0');
fsPromises.open("path").then((filehandle) => {
    // FileSystemAccessWrite
    filehandle.appendFile("dataaaaaaa")
    filehandle.write(buf).then(r => r.buffer);
    filehandle.writev(buf).then(r => r.buffers);
    filehandle.writeFile("dataNode");
    // FileSystemReadAccess
    filehandle.read(buf).then(r => r.buffer);
    filehandle.readv(buf).then(r => r.buffers);
    filehandle.readFile().then(r => r);
    filehandle.readLines();
})

const result = await fs.promises.open("src")
// FileSystemReadAccess
const readStream = result.promises.createReadStream();
// FileSystemAccessWrite
const writeStream = result.promises.createWriteStream();
readStream.pipe(zlib.createGzip()).pipe(writeStream);
import { pipeline } from 'stream/promises';

await pipeline(
    readStream,
    zlib.createGzip(),
    writeStream
)
fsPromises.readFile("src").then((r) => r.buffer);
const readFileResult = await fsPromises.readFile("src");
readFileResult.buffer;
fsPromises.writeFile("src", "dataNode");