const fs = require('fs');
const source = fs.createReadStream('source.txt');
const destination = fs.createWriteStream('destination.txt');

// Bad: Only destination has error handling, source errors are unhandled
source.pipe(destination).on('error', (err) => {
  console.error('Destination error:', err);
});
