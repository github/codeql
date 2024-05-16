const decompress = require('decompress');
const express = require('express')
const fileUpload = require("express-fileupload");

const app = express();
app.use(fileUpload());
app.listen(3000, () => {
});

app.post('/upload', async (req, res) => {
    decompress(req.query.filePath, 'dist').then(files => {
        console.log('done!');
    });

    res.send("OK")
});
