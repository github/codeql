const fs = require('fs');
const tmp = require('tmp');

const file = tmp.fileSync().name;
fs.writeFileSync(file, "content");