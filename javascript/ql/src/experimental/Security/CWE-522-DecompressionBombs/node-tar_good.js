const tar = require("tar");

tar.x({
    file: tarFileName,
    strip: 1,
    C: 'some-dir',
    maxReadSize: 16 * 1024 * 1024 // 16 MB
})