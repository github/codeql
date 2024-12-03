function badEncode(s) {
  return s.replace(/"/g, "&quot;")
          .replace(/'/g, "&apos;")
          .replace(/&/g, "&amp;");
}

function goodEncode(s) {
  return s.replace(/&/g, "&amp;")
          .replace(/"/g, "&quot;")
          .replace(/'/g, "&apos;");
}

function goodDecode(s) {
  return s.replace(/&quot;/g, "\"")
          .replace(/&apos;/g, "'")
          .replace(/&amp;/g, "&");
}

function badDecode(s) {
  return s.replace(/&amp;/g, "&")
          .replace(/&quot;/g, "\"")
          .replace(/&apos;/g, "'");
}

function cleverEncode(code) {
    return code.replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/&(?![\w\#]+;)/g, '&amp;');
}

function badDecode2(s) {
  return s.replace(/&amp;/g, "&")
          .replace(/s?ome|thin*g/g, "else")
          .replace(/&apos;/g, "'");
}

function goodDecodeInLoop(ss) {
  var res = [];
  for (var s of ss) {
    s = s.replace(/&quot;/g, "\"")
         .replace(/&apos;/g, "'")
         .replace(/&amp;/g, "&");
    res.push(s);
  }
  return res;
}

function badDecode3(s) {
  s = s.replace(/&amp;/g, "&");
  s = s.replace(/&quot;/g, "\"");
  return s.replace(/&apos;/g, "'");
}

function badUnescape(s) {
  return s.replace(/\\\\/g, '\\')
           .replace(/\\'/g, '\'')
           .replace(/\\"/g, '\"');
}

function badPercentEscape(s) {
  s = s.replace(/&/g, '%26');
  s = s.replace(/%/g, '%25');
  return s;
}

function badEncode(s) {
  var indirect1 = /"/g;
  var indirect2 = /'/g;
  var indirect3 = /&/g;
  return s.replace(indirect1, "&quot;")
          .replace(indirect2, "&apos;")
          .replace(indirect3, "&amp;");
}

function badEncodeWithReplacer(s) {
  var repl = {
    '"': "&quot;",
    "'": "&apos;",
    "&": "&amp;"
  };
  return s.replace(/["']/g, (c) => repl[c]).replace(/&/g, "&amp;");
}

// dubious, but out of scope for this query
function badRoundtrip(s) {
  return s.replace(/\\\\/g, "\\").replace(/\\/g, "\\\\");
}

function testWithCapturedVar(x) {
  var captured = x;
  (function() {
    captured = captured.replace(/\\/g, "\\\\");
  })();
}

function encodeDecodeEncode(s) {
 return goodEncode(goodDecode(goodEncode(s)));
}

function badEncode(s) {
  return s.replace(new RegExp("\"", "g"), "&quot;")
          .replace(new RegExp("\'", "g"), "&apos;")
          .replace(new RegExp("&", "g"), "&amp;"); // NOT OK
}

function goodEncode(s) {
  return s.replace(new RegExp("\"", ""), "&quot;")
          .replace(new RegExp("\'", ""), "&apos;")
          .replace(new RegExp("&", ""), "&amp;"); // OK
}

function goodEncode(s) {
  return s.replace(new RegExp("\"", unknownFlags()), "&quot;")
          .replace(new RegExp("\'", unknownFlags()), "&apos;")
          .replace(new RegExp("&", unknownFlags()), "&amp;"); // OK
}
