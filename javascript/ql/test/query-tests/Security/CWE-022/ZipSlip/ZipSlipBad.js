const fs = require('fs');
const unzip = require('unzip');

fs.createReadStream('archive.zip')
  .pipe(unzip.Parse())
  .on('entry', entry => {
    const fileName = entry.path;
    entry.pipe(fs.createWriteStream(fileName));
  });

var Writer = require('fstream').Writer;
fs.createReadStream('archive.zip')
  .pipe(unzip.Parse())
  .on('entry', entry => {
    const fileName = entry.path;
    entry.pipe(Writer({path: fileName}));
  });

fs.createReadStream('archive.zip')
  .pipe(unzip.Parse())
  .on('entry', entry => {
    const fileName = entry.path;
    var file = fs.openSync(fileName, "w");
  });

const JSZip = require('jszip');
const zip = new JSZip();
const path = require('path');
function doZipSlip() {
  for (const name in zip.files) {
    fs.createWriteStream(name);
  }

  zip.forEach((name, file) => {
    fs.createWriteStream(name);
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
    fs.createWriteStream(path.join(extractTo, file)); // OK
  }
}
