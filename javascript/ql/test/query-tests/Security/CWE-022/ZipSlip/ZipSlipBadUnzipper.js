const fs = require('fs');
const unzipper = require('unzipper');

fs.createReadStream('path/to/archive.zip')
  .pipe(unzipper.Parse())
  .on('entry', function (entry) {
    var fileName = entry.path;
    entry.pipe(fs.createWriteStream(fileName));
  });
