import express from 'express';
import Ajv from 'ajv';

let app = express();
let ajv = new Ajv();

ajv.addSchema({type: 'object', additionalProperties: {type: 'number'}}, 'pollData');

app.post('/polldata', (req, res) => {
    if (!ajv.validate('pollData', req.body)) {
        res.send(ajv.errorsText());
    }
});
