const express = require('express');

const app = express();

function escapeHtml(s) {
  return s.replaceAll("&", "&amp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;");
}

function escapeQuotes(s) {
  return s.replaceAll('"', "&quot;").replaceAll("'", "&#39;");
}

const LT = "<";

app.get('/a', function (req, res) {
  const name = req.query.name; // $ Source

  res.send("<p>" + escapeHtml(name) + "</p>");
  res.send("<p>" + name.replaceAll(/</g, "&lt;") + "</p>");
  res.send("<p>" + name.replaceAll(LT, "&lt;") + "</p>");
  res.send('<a title="' + escapeQuotes(name) + '">x</a>');

  res.send("<p>" + name.replace("<", "&lt;") + "</p>"); // $ Alert - only replaces the first `<`
  res.send("<p>" + name.replaceAll("&", "&amp;") + "</p>"); // $ Alert - does not escape `<`
  res.send("<p>" + name.replaceAll("<script>", "") + "</p>"); // $ Alert - not a meta-character
});
