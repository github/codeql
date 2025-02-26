const fs = require('fs');
const unzipper = require('unzipper');

fs.createReadStream('path/to/archive.zip')
  .pipe(unzipper.Parse())
  .on('entry', function (entry) {
    var fileName = entry.path; // $ Alert
    entry.pipe(fs.createWriteStream(fileName)); // $ Sink
  });
