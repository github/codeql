const fs = require("fs");
const os = require("os");
const path = require("path");

const filePath = path.join(os.tmpdir(), "my-temp-file.txt");

if (!fs.existsSync(filePath)) {
  fs.writeFileSync(filePath, "Hello", { mode: 0o600 }); // NOT OK
}

const filePath2 = createFile();
const stats = fs.statSync(filePath2);
if (doSomethingWith(stats)) {
  fs.writeFileSync(filePath2, "content"); // NOT OK
}

fs.access(filePath2, fs.constants.F_OK, (err) => {
  fs.writeFileSync(filePath2, "content"); // NOT OK
});

fs.open("myFile", "rw", (err, fd) => {
  fs.writeFileSync(fd, "content"); // OK
});

import { open, close } from "fs";

fs.access("myfile", (err) => {
  if (!err) {
    console.error("myfile already exists");
    return;
  }

  fs.open("myfile", "wx", (err, fd) => { // NOT OK
    if (err) throw err;

    // ....
  });
});

const filePath3 = createFile();
if (fs.existsSync(filePath3)) {
  fs.readFileSync(filePath3); // OK - a read after an existence check is OK 
}

const filePath4 = createFile();
while(Math.random() > 0.5) {
    fs.open(filePath4); // OK - it is only ever opened here.
}