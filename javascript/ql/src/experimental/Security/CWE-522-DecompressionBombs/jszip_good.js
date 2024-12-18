const jszipp = require("jszip");
function zipBombSafe(zipFile) {
    jszipp.loadAsync(zipFile.data).then(function (zip) {
        if (zip.file("10GB")["_data"]["uncompressedSize"] > 1024 * 1024 * 8) {
            console.log("error")
        }
        zip.file("10GB").async("uint8array").then(function (u8) {
            console.log(u8);
        });
    });
}