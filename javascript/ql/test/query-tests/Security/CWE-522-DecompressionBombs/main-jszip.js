const jszipp = require("jszip");
const express = require('express')
const fileUpload = require("express-fileupload");
const fs = require("fs");
const JSZip = require("jszip");
const app = express();
const port = 3000;
app.use(fileUpload());
app.listen(port, () => {
    console.log(`Example app listening on port ${port}`)
});

app.post('/upload', (req, res) => {
    let tmpObj = {"a": req.files.zipBombFile}
    zipBomb(tmpObj["a"])
    zipBombSafe(tmpObj["a"])
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

// local example
function localZipLoad(path) {
    fs.readFile(path
        , function (err, data) {
            if (err) throw err;
            JSZip.loadAsync(data).then((zip) => {
                console.log(zip);
                console.log(zip.files["10GB"]);
            });
        });

}

module.exports = {localZipLoad};