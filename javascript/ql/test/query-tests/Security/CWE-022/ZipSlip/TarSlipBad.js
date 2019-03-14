const fs = require('fs');
const tar = require('tar-stream');
const extract = tar.extract();

extract.on('entry', (header, stream, next) => {
  const out = fs.createWriteStream(header.name);
  stream.pipe(out);
  stream.on('end', () => {
    next();
  })
  stream.resume();
})

extract.on('finish', ()  => {
  console.log('finished');
});

fs.createReadStream('./bad.tar').pipe(extract);
