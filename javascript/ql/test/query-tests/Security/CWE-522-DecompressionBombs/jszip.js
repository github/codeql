const jszipp = require("jszip");
const express = require('express')
const fileUpload = require("express-fileupload");
const app = express();
const port = 3000;
app.use(fileUpload());
app.listen(port, () => {
    console.log(`Example app listening on port ${port}`)
});

app.post('/upload', (req, res) => {
    zipBomb(req.files.zipBombFile.data)
    zipBombSafe(req.files.zipBombFile.data)
    res.send("OK")
});

function zipBombSafe(zipFile) {
    jszipp.loadAsync(zipFile.data).then(function (zip) {
        if (zip.file("10GB")["_data"]["uncompressedSize"] > 1024 * 1024 * 8) {
            console.log("error")
            return
        }
        zip.files["10GB"].async("uint8array").then(function (u8) {
            console.log(u8);
        });
        zip.file("10GB").async("uint8array").then(function (u8) {
            console.log(u8);
        });
    });
}

function zipBomb(zipFile) {
    jszipp.loadAsync(zipFile.data).then(function (zip) {
        zip.files["10GB"].async("uint8array").then(function (u8) {
            console.log(u8);
        });
        zip.file("10GB").async("uint8array").then(function (u8) {
            console.log(u8);
        });
    });
}


module.exports = { localZipLoad };