import express from 'express';
import { WebView } from 'react-native';

var app = express();

app.get('/some/path', function(req, res) {
  let tainted = req.param("code"); // $ Source
  <WebView html={tainted}/>;            // $ Alert
  <WebView source={{html: tainted}}/>;  // $ Alert
});
