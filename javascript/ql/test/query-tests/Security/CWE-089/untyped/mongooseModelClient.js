import { MyModel } from './mongooseModel';
import express from 'express';
import bodyParser from 'body-parser';

let app = express();

app.use(bodyParser.json());

app.post('/find', (req, res) => {
  let v = JSON.parse(req.body.x); // $ Source
  MyModel.find({ id: v }); // $ Alert
  MyModel.find({ id: req.body.id }); // $ Alert
  MyModel.find({ id: `${req.body.id}` });
});
