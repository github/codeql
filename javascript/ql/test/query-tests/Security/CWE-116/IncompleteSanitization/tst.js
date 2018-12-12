let express = require('express');
var app = express();

function bad1(s) {
  return s.replace("'", ""); // NOT OK
}

function bad2(s) {
  return s.replace(/'/, ""); // NOT OK
}

function bad3(s) {
  return s.replace(/'/g, "\\'"); // NOT OK
}

function bad4(s) {
  return s.replace(/'/g, "\\$&"); // NOT OK
}

function bad5(s) {
  return s.replace(/['"]/g, "\\$&"); // NOT OK
}

function bad6(s) {
  return s.replace(/(['"])/g, "\\$1"); // NOT OK
}

function bad7(s) {
  return s.replace(/('|")/g, "\\$1"); // NOT OK
}

function bad8(s) {
  return s.replace('|', '');  // NOT OK
}

function bad9(s) {
  return s.replace(/"/g, "\\\"");  // NOT OK
}

function bad10(s) {
  return s.replace("/", "%2F"); // NOT OK
}

function bad11(s) {
  return s.replace("%25", "%"); // NOT OK
}


function good1(s) {
  while (s.indexOf("'") > 0)
    s = s.replace("'", ""); // OK
  return s;
}

function good2(s) {
  while (s.indexOf("'") > 0)
    s = s.replace(/'/, ""); // OK
  return s;
}

function good3(s) {
  return s.replace("@user", "id10t"); // OK
}

function good4(s) {
  return s.replace(/#/g, "\\d+"); // OK
}

function good5(s) {
  return s.replace(/\\/g, "\\\\").replace(/['"]/g, "\\$&"); // OK
}

function good6(s) {
  return s.replace(/[\\]/g, '\\\\').replace(/[\"]/g, '\\"'); // OK
}

function good7(s) {
  s = s.replace(/[\\]/g, '\\\\');
  return s.replace(/[\"]/g, '\\"'); // OK
}

function good8(s) {
  return s.replace(/\W/g, '\\$&'); // OK
}

function good9(s) {
  return s.replace(/[^\w\s]/g, '\\$&'); // OK
}

function good10(s) {
  s = JSON.stringify(s);  // NB: escapes backslashes
  s = s.slice(1, -1);
  s = s.replace(/\\"/g, '"');
  s = s.replace(/'/g, "\\'"); // OK
  return "'" + s + "'";
}

function flowifyComments(s) {
  return s.replace(/#/g, '💩'); // OK
}

function good11(s) {
  return s.replace("%d", "42");
}

app.get('/some/path', function(req, res) {
  let untrusted = req.param("p");

  // the query doesn't currently check whether untrusted input flows into the
  // sanitiser, but we add these calls anyway to make the tests more realistic

  bad1(untrusted);
  bad2(untrusted);
  bad3(untrusted);
  bad4(untrusted);
  bad5(untrusted);
  bad6(untrusted);
  bad7(untrusted);
  bad8(untrusted);
  bad9(untrusted);
  bad10(untrusted);
  bad11(untrusted);

  good1(untrusted);
  good2(untrusted);
  good3(untrusted);
  good4(untrusted);
  good5(untrusted);
  good6(untrusted);
  good7(untrusted);
  good8(untrusted);
  good9(untrusted);
  good10(untrusted);
  flowifyComments(untrusted);
  good11(untrusted);
});
