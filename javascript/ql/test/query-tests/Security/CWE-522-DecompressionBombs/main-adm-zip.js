// const AdmZip = require("adm-zip");
//
// // reading archives
// var zip = new AdmZip("/home/am/0_WorkDir/1_CodeQL Workspace/Bombs scripts and payloads/2GB.zip");
// var zipEntries = zip.getEntries(); // an array of ZipEntry records
//
// zipEntries.forEach(function (zipEntry) {
//     console.log(zipEntry.toString()); // outputs zip entries information
//     if (zipEntry.entryName == "my_file.txt") {
//         console.log(zipEntry.getData().toString("utf8"));
//     }
// });
// // outputs the content of some_folder/my_file.txt
// console.log(zip.readAsText("10GB"));
// // extracts the specified file to the specified location
// zip.extractEntryTo("10GB", "/home/me/tempfolder", false, true);
// // extracts everything
// zip.extractAllTo("./tmp", true);

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