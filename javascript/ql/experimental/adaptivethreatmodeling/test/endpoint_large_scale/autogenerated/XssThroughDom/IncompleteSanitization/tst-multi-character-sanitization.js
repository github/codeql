// CVE-2019-10756
(function(content) {
  content = content.replace(/<.*cript.*\/scrip.*>/gi, ""); // NOT OK
  content = content.replace(/ on\w+=".*"/g, ""); // NOT OK
  content = content.replace(/ on\w+=\'.*\'/g, ""); // NOT OK
  return content;
});
(function(content) {
  content = content.replace(/<.*cript.*/gi, ""); // NOT OK
  content = content.replace(/.on\w+=.*".*"/g, ""); // NOT OK
  content = content.replace(/.on\w+=.*\'.*\'/g, ""); // NOT OK

  return content;
});

// CVE-2020-7656
(function(responseText) {
  var rscript = /<script\b[^<]*(?:(?!<\/script>)<[^<]*)*<\/script>/gi;
  responseText.replace(rscript, ""); // NOT OK
  return responseText;
});

// CVE-2019-1010091
(function(text) {
  text = text.replace(/<!--|--!?>/g, ""); // NOT OK
  return text;
});
(function(text) {
  while (/<!--|--!?>/g.test(text)) {
    text = text.replace(/<!--|--!?>/g, ""); // OK
  }

  return text;
});

// CVE-2019-10767
(function(id) {
  id = id.replace(/\.\./g, ""); // OK (can not contain '..' afterwards)
  return id;
});
(function(id) {
  id = id.replace(/[\]\[*,;'"`<>\\?\/]/g, ""); // OK (or is it?)
  return id;
});

// CVE-2019-8903
(function(req) {
  var REG_TRAVEL = /(\/)?\.\.\//g;
  req.url = req.url.replace(REG_TRAVEL, ""); // NOT OK
});
(function(req) {
  var beg;
  for (var i = 0; i < req.url.length; i++) {
    if (req.url[i] === "." && req.url[i + 1] === "/") beg = i + 1;
    else if (req.url[i] === "?") break;
  }

  if (beg) req.url = req.url.substring(beg);
});

// New cases

(function(x) {
  x = x.replace(/<script\b[^<]*(?:(?!<\/script>)<[^<]*)*<\/script>/g, ""); // NOT OK

  x = x.replace(/(\/|\s)on\w+=(\'|")?[^"]*(\'|")?/g, ""); // NOT OK

  x = x.replace(/<\/script>/g, ""); // OK

  x = x.replace(/<(.)?br(.)?>/g, ""); // OK
  x = x.replace(/<\/?b>/g, ""); // OK
  x = x.replace(/<(ul|ol)><\/(ul|ol)>/gi, ""); // OK
  x = x.replace(/<li><\/li>/gi, ""); // OK

  x = x.replace(/<!--(.*?)-->/gm, ""); // NOT OK
  x = x.replace(/\sng-[a-z-]+/, ""); // NOT OK
  x = x.replace(/\sng-[a-z-]+/g, ""); // NOT OK (ng-attributes)

  x = x.replace(/(<!--\[CDATA\[|\]\]-->)/g, "\n"); // OK: not a sanitizer

  x = x.replace(/<script.+desktop\-only.+<\/script>/g, ""); // OK [INCONSISTENCY]
  x = x.replace(/<script async.+?<\/script>/g, ""); // OK
  x = x.replace(/<!--[\s\S]*?-->|<\?(?:php)?[\s\S]*?\?>/gi, ""); // NOT OK

  x = x.replace(/\x2E\x2E\x2F\x2E\x2E\x2F/g, ""); // NOT OK (matches "../../")

  x = x.replace(/<script.*>.*<\/script>/gi, ""); // NOT OK

  x = x.replace(/^(\.\.\/?)+/g, ""); // OK

  // NOT OK
  x = x.replace(/<script\b[^<]*(?:(?!<\/script>)<[^<]*)*<\/script>/g, function(
    $0
  ) {
    return unknown ? $0 : "";
  });

  x = x.replace(/<\/?([a-z][a-z0-9]*)\b[^>]*>/gi, ""); // NOT OK [INCONSISTENCY]

  x = x.replace(/\.\./g, ""); // OK
  x = x.replace(/\.\.\//g, ""); // NOT OK
  x = x.replace(/\/\.\./g, ""); // NOT OK

  x = x.replace(/<script(.*?)>([\s\S]*?)<\/script>/gi, ""); // NOT OK

  x = x.replace(/<(script|del)(?=[\s>])[\w\W]*?<\/\1\s*>/gi, ""); // NOT OK
  x = x.replace(/\<script[\s\S]*?\>[\s\S]*?\<\/script\>/g, ""); // NOT OK
  x = x.replace(/<(script|style|title)[^<]+<\/(script|style|title)>/gm, ""); // NOT OK
  x = x.replace(/<script[^>]*>([\s\S]*?)<\/script>/gi, ""); // NOT OK
  x = x.replace(/<script[\s\S]*?<\/script>/gi, ""); // NOT OK
  x = x.replace(/ ?<!-- ?/g, ""); // NOT OK
  x = x.replace(/require\('\.\.\/common'\);/g, ""); // OK
  x = x.replace(/\.\.\/\.\.\/lib\//g, ""); // OK

  while (x.indexOf(".") !== -1) {
    x = x
      .replace(/^\.\//, "")
      .replace(/\/\.\//, "/")
      .replace(/[^\/]*\/\.\.\//, ""); // OK
  }

  x = x.replace(/([^.\s]+\.)+/, ""); // OK

  x = x.replace(/<!\-\-DEVEL[\d\D]*?DEVEL\-\->/g, ""); // OK

  x = x
    .replace(/^\.\//, "")
    .replace(/\/\.\//, "/")
    .replace(/[^\/]*\/\.\.\//, ""); // NOT OK

  return x;
});

(function (content) {
	content.replace(/<script.*\/script>/gi, ""); // NOT OK
	content.replace(/<(script).*\/script>/gi, ""); // NOT OK
	content.replace(/.+<(script).*\/script>/gi, ""); // NOT OK
	content.replace(/.*<(script).*\/script>/gi, ""); // NOT OK
});

(function (content) {
  content = content.replace(/<script[\s\S]*?<\/script>/gi, ""); // NOT OK
  content = content.replace(/<[a-zA-Z\/](.|\n)*?>/g, '') || ' '; // NOT OK
  content = content.replace(/<(script|iframe|video)[\s\S]*?<\/(script|iframe|video)>/g, '') // NOT OK
  content = content.replace(/<(script|iframe|video)(.|\s)*?\/(script|iframe|video)>/g, '') // NOT OK
  content = content.replace(/<[^<]*>/g, ""); // OK

  n.cloneNode(false).outerHTML.replace(/<\/?[\w:\-]+ ?|=[\"][^\"]+\"|=\'[^\']+\'|=[\w\-]+|>/gi, '').replace(/[\w:\-]+/gi, function(a) { // NOT OK
    o.push({specified : 1, nodeName : a});
  });

  n.cloneNode(false).outerHTML.replace(/<\/?[\w:\-]+ ?|=[\"][^\"]+\"|=\'[^\']+\'|=[\w\-]+|>/gi, '').replace(/[\w:\-]+/gi, function(a) { // NOT OK
    o.push({specified : 1, nodeName : a});
  });  
});