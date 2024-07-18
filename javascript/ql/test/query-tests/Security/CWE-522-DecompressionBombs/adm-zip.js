const AdmZip = require("adm-zip");
const express = require('express')
const fileUpload = require("express-fileupload");
const fs = require("fs");
const app = express();
const port = 3000;
app.use(fileUpload());
app.listen(port, () => {
    console.log(`Example app listening on port ${port}`)
});

app.post('/upload', (req, res) => {
    zipBomb(req.files.zipBombFile)
    res.send('Hello World!')
});

function zipBomb(tarFile) {
    fs.writeFileSync(tarFile.name, tarFile.data);
    // or using fs.writeFile

    // file path is a tmp file name that can get from DB after saving to DB with remote file upload
    // so the input file name will come from a DB source
    const admZip
        = new AdmZip(tarFile.data);
    const zipEntries = admZip.getEntries();
    zipEntries.forEach(function (zipEntry) {
        if (zipEntry.entryName === "my_file.txt") {
            console.log(zipEntry.getData().toString("utf8"));
        }
    });
    // outputs the content of file named 10GB
    console.log(admZip.readAsText("10GB"));
    // extracts the specified file to the specified location
    admZip.extractEntryTo("10GB", "/tmp/", false, true);
    // extracts everything
    admZip.extractAllTo("./tmp", true);
}