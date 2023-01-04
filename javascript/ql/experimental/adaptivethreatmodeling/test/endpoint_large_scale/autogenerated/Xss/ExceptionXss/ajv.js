import express from 'express';
import Ajv from 'ajv';

let app = express();
let ajv = new Ajv();

ajv.addSchema({type: 'object', additionalProperties: {type: 'number'}}, 'pollData');

app.post('/polldata', (req, res) => {
    if (!ajv.validate('pollData', req.body)) {
        res.send(ajv.errorsText()); // NOT OK
    }
});

const joi = require("joi");
const joiSchema = joi.object().keys({
    name: joi.string().required(),
    age: joi.number().required()
}).with('name', 'age');

app.post('/votedata', (req, res) => {
    const val = joiSchema.validate(req.body);
    if (val.error) {
        res.send(val.error); // NOT OK
    }
});