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
    zipBomb1(req.files.zipBombFile.data);
    zipBomb2(req.files.zipBombFile.data);
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