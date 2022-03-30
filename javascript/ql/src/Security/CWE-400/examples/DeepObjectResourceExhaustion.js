import express from 'express';
import Ajv from 'ajv';

let ajv = new Ajv({ allErrors: true });
ajv.addSchema(require('./input-schema'), 'input');

var app = express();
app.get('/user/:id', function(req, res) {
	if (!ajv.validate('input', req.body)) {
		res.end(ajv.errorsText());
		return;
	}
	// ...
});
