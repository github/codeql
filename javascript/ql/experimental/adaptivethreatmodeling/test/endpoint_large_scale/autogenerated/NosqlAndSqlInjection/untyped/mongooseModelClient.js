import { MyModel } from './mongooseModel';
import express from 'express';
import bodyParser from 'body-parser';

let app = express();

app.use(bodyParser.json());

app.post('/find', (req, res) => {
  let v = JSON.parse(req.body.x);
  MyModel.find({ id: v }); // NOT OK
  MyModel.find({ id: req.body.id }); // NOT OK
  MyModel.find({ id: `${req.body.id}` }); // OK
});
