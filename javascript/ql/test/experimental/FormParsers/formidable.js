import http from 'node:http';
import formidable from 'formidable';
const sink = require('sink');

const server = http.createServer(async (req, res) => {
    const form = formidable({});
    const [fields, files] = await form.parse(req);
    sink(fields, files)
    form.on('fileBegin', (formname, file) => {
        sink(formname, file)
    });
    form.on('file', (formname, file) => {
        sink(formname, file)
    });
    form.on('field', (fieldName, fieldValue) => {
        sink(fieldName, fieldValue)
    });
});

server.listen(8080, () => {
    console.log('Server listening on http://localhost:8080/ ...');
});