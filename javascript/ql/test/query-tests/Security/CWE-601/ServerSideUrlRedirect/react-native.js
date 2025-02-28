import express from 'express';
import { WebView } from 'react-native';

var app = express();

app.get('/some/path', function(req, res) {
  let tainted = req.param("code"); // $ Source
  <WebView url={tainted}/>;            // $ Alert
  <WebView source={{uri: tainted}}/>;  // $ Alert
});
