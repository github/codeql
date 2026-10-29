const zlib = require("zlib");

zlib.gunzip(
    inputZipFile.data,
    { maxOutputLength: 1024 * 1024 * 5 },
    (err, buffer) => {
        doSomeThingWithData(buffer);
    });
zlib.gunzipSync(inputZipFile.data, { maxOutputLength: 1024 * 1024 * 5 });

inputZipFile.pipe(zlib.createGunzip({ maxOutputLength: 1024 * 1024 * 5 })).pipe(outputFile);