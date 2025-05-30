const fs = require('fs');
const source = fs.createReadStream('source.txt');
const destination = fs.createWriteStream('destination.txt');

// Bad: No error handling
source.pipe(destination);
