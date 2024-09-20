const fflate = require('fflate');
const express = require('express')
const fileUpload = require("express-fileupload");

const { writeFileSync } = require("fs");
const app = express();
app.use(fileUpload());
app.listen(3000, () => {
});

app.post('/upload', async (req, res) => {
    // NOT OK
    fflate.unzlibSync(new Uint8Array(req.files.CompressedFile.data));
    fflate.unzip(new Uint8Array(new Uint8Array(req.files.CompressedFile.data)));
    fflate.unzlib(new Uint8Array(req.files.CompressedFile.data));
    fflate.unzlibSync(new Uint8Array(req.files.CompressedFile.data));
    fflate.gunzip(new Uint8Array(req.files.CompressedFile.data));
    fflate.gunzipSync(new Uint8Array(req.files.CompressedFile.data));
    fflate.decompress(new Uint8Array(req.files.CompressedFile.data));
    fflate.decompressSync(new Uint8Array(req.files.CompressedFile.data));

    // OK
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
