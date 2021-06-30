const path = require('path');

const alias = path.resolve(__dirname, "folderA");

module.exports = {
    resolve: {
        alias: {
            "@": alias,
            "%": path.resolve(__dirname, "folderB"),
            "#": path.resolve(__dirname, "../folderA"),
            "~": "folderB",
        }
    }
}
