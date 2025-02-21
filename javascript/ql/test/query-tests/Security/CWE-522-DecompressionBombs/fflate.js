const fflate = require('fflate');
const express = require('express')
const fileUpload = require("express-fileupload");

const { writeFileSync } = require("fs");
const app = express();
app.use(fileUpload());
app.listen(3000, () => {
});

app.post('/upload', async (req, res) => {
    // Not sure if these are vulnerable, but currently not modeled
    fflate.unzlibSync(new Uint8Array(req.files.CompressedFile.data)); // $ MISSING: Alert
    fflate.unzip(new Uint8Array(new Uint8Array(req.files.CompressedFile.data))); // $ MISSING: Alert
    fflate.unzlib(new Uint8Array(req.files.CompressedFile.data)); // $ MISSING: Alert
    fflate.unzlibSync(new Uint8Array(req.files.CompressedFile.data)); // $ MISSING: Alert
    fflate.gunzip(new Uint8Array(req.files.CompressedFile.data)); // $ MISSING: Alert
    fflate.gunzipSync(new Uint8Array(req.files.CompressedFile.data)); // $ MISSING: Alert
    fflate.decompress(new Uint8Array(req.files.CompressedFile.data)); // $ MISSING: Alert
    fflate.decompressSync(new Uint8Array(req.files.CompressedFile.data)); // $ MISSING: Alert


    fflate.unzlibSync(new Uint8Array(req.files.CompressedFile.data), {
        filter(file) {
            return file.originalSize <= 1_000_000;
        }
    });
    fflate.unzip(new Uint8Array(new Uint8Array(req.files.CompressedFile.data)), {
        filter(file) {
            return file.originalSize <= 1_000_000;
        }
    });
    fflate.unzlib(new Uint8Array(req.files.CompressedFile.data), {
        filter(file) {
            return file.originalSize <= 1_000_000;
        }
    });
    fflate.unzlibSync(new Uint8Array(req.files.CompressedFile.data), {
        filter(file) {
            return file.originalSize <= 1_000_000;
        }
    });
    fflate.gunzip(new Uint8Array(req.files.CompressedFile.data), {
        filter(file) {
            return file.originalSize <= 1_000_000;
        }
    });
    fflate.gunzipSync(new Uint8Array(req.files.CompressedFile.data), {
        filter(file) {
            return file.originalSize <= 1_000_000;
        }
    });
    fflate.decompress(new Uint8Array(req.files.CompressedFile.data), {
        filter(file) {
            return file.originalSize <= 1_000_000;
        }
    });
    fflate.decompressSync(new Uint8Array(req.files.CompressedFile.data), {
        filter(file) {
            return file.originalSize <= 1_000_000;
        }
    });
});
