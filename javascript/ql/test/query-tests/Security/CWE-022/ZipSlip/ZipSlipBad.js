const fs = require('fs');
const unzip = require('unzip');

fs.createReadStream('archive.zip')
  .pipe(unzip.Parse())
  .on('entry', entry => {
    const fileName = entry.path; // $ Alert
    entry.pipe(fs.createWriteStream(fileName)); // $ Sink
  });

var Writer = require('fstream').Writer;
fs.createReadStream('archive.zip')
  .pipe(unzip.Parse())
  .on('entry', entry => {
    const fileName = entry.path; // $ Alert
    entry.pipe(Writer({path: fileName})); // $ Sink
  });

fs.createReadStream('archive.zip')
  .pipe(unzip.Parse())
  .on('entry', entry => {
    const fileName = entry.path; // $ Alert
    var file = fs.openSync(fileName, "w"); // $ Sink
  });

const JSZip = require('jszip');
const zip = new JSZip();
const path = require('path');
function doZipSlip() {
  for (const name in zip.files) { // $ Alert
    fs.createWriteStream(name); // $ Sink
  }

  zip.forEach((name, file) => { // $ Alert
    fs.createWriteStream(name); // $ Sink
  });

  const extractTo = path.resolve("/some/path/to/extract/to");
  var files = [];

  for (var name in zip.files) {
    var entry = zip.files[name];

    var targetPath = path.resolve(
      path.join(extractTo, name)
    );
    if (!targetPath.startsWith(extractTo)) {
      throw new Error("Entry is outside the extraction path");
    }
    files.push(name);
  }
  for (const file of files) {
    fs.createWriteStream(path.join(extractTo, file));
  }
}
