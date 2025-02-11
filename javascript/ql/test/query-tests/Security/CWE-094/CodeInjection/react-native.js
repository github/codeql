import express from 'express';
import { WebView } from 'react-native';

var app = express();

app.get('/some/path', function(req, res) {
  let tainted = req.param("code");
  <WebView injectedJavaScript={tainted}/>;  // $ Alert[js/code-injection]
  let wv = <WebView/>;
  wv.injectJavaScript(tainted);             // $ Alert[js/code-injection]
});
