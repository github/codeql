const { pipeline } = require('stream');
const fs = require('fs');
const source = fs.createReadStream('source.txt');
const destination = fs.createWriteStream('destination.txt');

// Good: Using pipeline for automatic error handling
pipeline(
  source,
  destination,
  (err) => {
    if (err) {
      console.error('Pipeline failed:', err);
    } else {
      console.log('Pipeline succeeded');
    }
  }
);
