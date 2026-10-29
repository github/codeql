const fs = require('fs');
const os = require('os');
const path = require('path');

const file = path.join(os.tmpdir(), "test-" + (new Date()).getTime() + ".txt");
fs.writeFileSync(file, "content");