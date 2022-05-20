const fs = require("fs");
const os = require("os");
const path = require("path");

const filePath = path.join(os.tmpdir(), "my-temp-file.txt");

try {
  const fd = fs.openSync(filePath, fs.O_CREAT | fs.O_EXCL | fs.O_RDWR, 0o600);

  fs.writeFileSync(fd, "Hello");
} catch (e) {
  // file existed
}
