const fs = require("fs");
const os = require("os");
const path = require("path");

const filePath = path.join(os.tmpdir(), "my-temp-file.txt");

if (!fs.existsSync(filePath)) {
  fs.writeFileSync(filePath, "Hello", { mode: 0o600 });
}
