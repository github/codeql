const fs = require('fs');
const unzip = require('unzip');

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
  });
