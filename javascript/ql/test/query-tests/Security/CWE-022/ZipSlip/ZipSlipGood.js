const fs = require('fs');
const unzip = require('unzip');
const path = require('path');

fs.createReadStream('archive.zip')
  .pipe(unzip.Parse())
  .on('entry', entry => {
    const fileName = entry.path;
    if (fileName.indexOf('..') == -1) {
      entry.pipe(fs.createWriteStream(fileName));
    }
    else {
      console.log('skipping bad path', fileName);
    }

    fs.createWriteStream(path.join(cwd, path.join('/', fileName)));
  });

fs.createReadStream('archive.zip')
  .pipe(unzip.Parse())
  .on('entry', entry => {
    const fileName = path.normalize(entry.path);

    if (path.isAbsolute(fileName)) {
      return;
    }

    if (!fileName.startsWith(".")) {
      entry.pipe(fs.createWriteStream(fileName)); // OK.
    }
  });

fs.createReadStream('archive.zip')
  .pipe(unzip.Parse())
  .on('entry', entry => {
    const fileName = path.normalize(entry.path);

    entry.pipe(fs.createWriteStream(path.basename(fileName))); // OK.
  });
