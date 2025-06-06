const fs = require('fs');
const source = fs.createReadStream('source.txt');
const destination = fs.createWriteStream('destination.txt');

// Alternative Good: Manual error handling with pipe()
source.on('error', (err) => {
  console.error('Source stream error:', err);
  destination.destroy(err);
});

destination.on('error', (err) => {
  console.error('Destination stream error:', err);
  source.destroy(err);
});

source.pipe(destination);
