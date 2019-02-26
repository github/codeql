const fs = require('fs');
const unzip = require('unzip');

fs.createReadStream('archive.zip')
  .pipe(unzip.Parse())
  .on('entry', entry => {
    const fileName = entry.path;
    if (entry.path.indexOf('..') == -1) {
      entry.pipe(fs.createWriteStream(entry.path));
    }
    else {
      console.log('skipping bad path', entry.path);
    }
  });
