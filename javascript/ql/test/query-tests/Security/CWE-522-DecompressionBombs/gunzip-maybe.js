const gunzipmaybe = require("gunzip-maybe");
const express = require('express')
const fileUpload = require("express-fileupload");
const { Readable } = require('stream');
const app = express();
app.use(fileUpload());
app.listen(3000, () => {
});

app.post('/upload', async (req, res) => {
    // Unsafe
    const RemoteStream = Readable.from(req.files.ZipFile.data);
    RemoteStream.pipe(gunzipmaybe).createWriteStream("tmp")
});