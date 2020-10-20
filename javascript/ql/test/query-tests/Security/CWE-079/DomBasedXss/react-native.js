import express from 'express';
import { WebView } from 'react-native';

var app = express();

app.get('/some/path', function(req, res) {
  let tainted = req.param("code");
  <WebView html={tainted}/>;            // NOT OK
  <WebView source={{html: tainted}}/>;  // NOT OK
});
