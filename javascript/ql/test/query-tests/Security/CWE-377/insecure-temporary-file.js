const os = require('os');
const uuid = require('node-uuid');
const fs = require('fs');
const path = require('path');

(function main() {
    var tmpLocation = path.join(
        os.tmpdir ? os.tmpdir() : os.tmpDir(), // $ Source
        'something',
        uuid.v4().slice(0, 8)
    );

    fs.writeFileSync(tmpLocation, content); // $ Alert

    var tmpPath = "/tmp/something"; // $ Source
    fs.writeFileSync(path.join("./foo/", tmpPath), content);
    fs.writeFileSync(path.join(tmpPath, "./foo/"), content); // $ Alert

    fs.writeFileSync(path.join(tmpPath, "./foo/"), content, {mode: 0o600});

    fs.writeFileSync(path.join(tmpPath, "./foo/"), content, {mode: mode}); // OK - assumed unknown mode is secure

    fs.writeFileSync(path.join(tmpPath, "./foo/"), content, {mode: 0o666}); // $ Alert - explicitly insecure

    const tmpPath2 = path.join(os.tmpdir(), `tmp_${Math.floor(Math.random() * 1000000)}.md`); // $ Source
    fs.writeFileSync(tmpPath2, content); // $ Alert

    fs.openSync(tmpPath2, 'w'); // $ Alert
    fs.openSync(tmpPath2, 'w', 0o600);
})
