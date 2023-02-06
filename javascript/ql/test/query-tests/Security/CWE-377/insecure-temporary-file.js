const os = require('os');
const uuid = require('node-uuid');
const fs = require('fs');
const path = require('path');

(function main() {
    var tmpLocation = path.join(
        os.tmpdir ? os.tmpdir() : os.tmpDir(),
        'something',
        uuid.v4().slice(0, 8)
    );

    fs.writeFileSync(tmpLocation, content); // NOT OK

    var tmpPath = "/tmp/something";
    fs.writeFileSync(path.join("./foo/", tmpPath), content); // OK
    fs.writeFileSync(path.join(tmpPath, "./foo/"), content); // NOT OK

    fs.writeFileSync(path.join(tmpPath, "./foo/"), content, {mode: 0o600}); // OK

    fs.writeFileSync(path.join(tmpPath, "./foo/"), content, {mode: mode}); // OK - assumed unknown mode is secure

    fs.writeFileSync(path.join(tmpPath, "./foo/"), content, {mode: 0o666}); // NOT OK - explicitly insecure

    const tmpPath2 = path.join(os.tmpdir(), `tmp_${Math.floor(Math.random() * 1000000)}.md`);
    fs.writeFileSync(tmpPath2, content); // NOT OK

    fs.openSync(tmpPath2, 'w'); // NOT OK
    fs.openSync(tmpPath2, 'w', 0o600); // OK
})
