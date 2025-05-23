const highland = require('highland');
const fs = require('fs');

highland(fs.createReadStream('input.txt'))  
  .map(line => {
    if (line.length === 0) throw new Error('Empty line');
    return line;
  }).pipe(fs.createWriteStream('output.txt')); // $SPURIOUS:Alert
