var bz2 = require('unbzip2-stream');
var fs = require('fs');
const express = require('express')
const fileUpload = require("express-fileupload");

const app = express();
app.use(fileUpload());
app.listen(3000, () => {
});

app.post('/upload', async (req, res) => {
    fs.createReadStream(req.query.FilePath).pipe(bz2()).pipe(process.stdout);
});
