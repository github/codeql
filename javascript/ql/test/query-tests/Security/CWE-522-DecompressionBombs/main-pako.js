const pako = require('pako');
const express = require('express')
const fileUpload = require("express-fileupload");
const app = express();
const port = 3000;
app.use(fileUpload());
app.listen(port, () => {
    console.log(`Example app listening on port ${port}`)
});

app.post('/upload', (req, res) => {
    zipBomb1(req.files.zipBombFile);
    zipBomb2(req.files.zipBombFile);
    res.send('Hello World!');
});

function zipBomb1(zipFile) {
    const myArray = Buffer.from(new Uint8Array(zipFile.data.buffer));
    let output;
    try {
        output = pako.inflate(myArray);
        console.log(output);
    } catch (err) {
        console.log(err);
    }
}

function zipBomb2(zipFile) {
    const myArray = new Uint8Array(zipFile.data.buffer).buffer;
    let output;
    try {
        output = pako.inflate(myArray);
        console.log(output);
    } catch (err) {
        console.log(err);
    }
}


//
// const pako = require('pako');
// const fs = require("fs")
// const myArrayBuffer = fs.readFileSync("/home/am/0_WorkDir/1_CodeQL Workspace/Bombs scripts and payloads/bomb.tar.gzip", null).buffer;
// // const myArray = new Uint16Array(toArrayBuffer(myArrayBuffer));
// // const myArray = Buffer.from(new Uint8Array(myArrayBuffer));
// const myArray = new Uint8Array(myArrayBuffer).buffer;
// try {
//     output = pako.inflate(myArray);
//     console.log(output)
// } catch (err) {
//     console.log(err);
// }