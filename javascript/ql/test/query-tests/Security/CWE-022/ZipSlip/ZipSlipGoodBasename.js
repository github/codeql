const fs = require('fs');
const unzip = require('unzip');
const path = require('path');

fs.createReadStream('archive.zip')
  .pipe(unzip.Parse())
  .on('entry', entry => {
    const fileName = entry.path;
    entry.pipe(fs.createWriteStream(path.join('my_directory', path.basename(fileName))));
  });
