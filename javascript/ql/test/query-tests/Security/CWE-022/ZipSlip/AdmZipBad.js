const fs = require('fs');
var AdmZip = require('adm-zip');
var zip = new AdmZip("archive.zip");
var zipEntries = zip.getEntries();
zipEntries.forEach(function(zipEntry) {
  fs.createWriteStream(zipEntry.entryName);
});
