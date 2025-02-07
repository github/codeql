// CVE-2019-10756
(function(content) {
  content = content.replace(/<.*cript.*\/scrip.*>/gi, ""); // $ Alert TODO-MISSING: Alert[js/unsafe-html-expansion] Alert[js/incomplete-sanitization] Alert[js/incomplete-html-attribute-sanitization]
  content = content.replace(/ on\w+=".*"/g, ""); // $ Alert TODO-MISSING: Alert[js/unsafe-html-expansion] Alert[js/incomplete-sanitization] Alert[js/incomplete-html-attribute-sanitization]
  content = content.replace(/ on\w+=\'.*\'/g, ""); // $ Alert TODO-MISSING: Alert[js/unsafe-html-expansion] Alert[js/incomplete-sanitization] Alert[js/incomplete-html-attribute-sanitization]
  return content;
});
(function(content) {
  content = content.replace(/<.*cript.*/gi, ""); // $ Alert TODO-MISSING: Alert[js/unsafe-html-expansion] Alert[js/incomplete-sanitization] Alert[js/incomplete-html-attribute-sanitization]
  content = content.replace(/.on\w+=.*".*"/g, ""); // $ Alert TODO-MISSING: Alert[js/unsafe-html-expansion] Alert[js/incomplete-sanitization] Alert[js/incomplete-html-attribute-sanitization]
  content = content.replace(/.on\w+=.*\'.*\'/g, ""); // $ Alert TODO-MISSING: Alert[js/unsafe-html-expansion] Alert[js/incomplete-sanitization] Alert[js/incomplete-html-attribute-sanitization]

  return content;
});

// CVE-2020-7656
(function(responseText) {
  var rscript = /<script\b[^<]*(?:(?!<\/script>)<[^<]*)*<\/script>/gi;
  responseText.replace(rscript, ""); // $ Alert TODO-MISSING: Alert[js/unsafe-html-expansion] Alert[js/incomplete-sanitization] Alert[js/incomplete-html-attribute-sanitization]
  return responseText;
});

// CVE-2019-1010091
(function(text) {
  text = text.replace(/<!--|--!?>/g, ""); // $ Alert TODO-MISSING: Alert[js/unsafe-html-expansion] Alert[js/incomplete-sanitization] Alert[js/incomplete-html-attribute-sanitization]
  return text;
});
(function(text) {
  while (/<!--|--!?>/g.test(text)) {
    text = text.replace(/<!--|--!?>/g, "");
  }

  return text;
});

// CVE-2019-10767
(function(id) {
  id = id.replace(/\.\./g, ""); // OK - can not contain '..' afterwards
  return id;
});
(function(id) {
  id = id.replace(/[\]\[*,;'"`<>\\?\/]/g, ""); // OK - or is it?
  return id;
});

// CVE-2019-8903
(function(req) {
  var REG_TRAVEL = /(\/)?\.\.\//g;
  req.url = req.url.replace(REG_TRAVEL, ""); // $ Alert TODO-MISSING: Alert[js/unsafe-html-expansion] Alert[js/incomplete-sanitization] Alert[js/incomplete-html-attribute-sanitization]
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
  x = x.replace(/<script\b[^<]*(?:(?!<\/script>)<[^<]*)*<\/script>/g, ""); // $ Alert TODO-MISSING: Alert[js/unsafe-html-expansion] Alert[js/incomplete-sanitization] Alert[js/incomplete-html-attribute-sanitization]

  x = x.replace(/(\/|\s)on\w+=(\'|")?[^"]*(\'|")?/g, ""); // $ Alert TODO-MISSING: Alert[js/unsafe-html-expansion] Alert[js/incomplete-sanitization] Alert[js/incomplete-html-attribute-sanitization]

  x = x.replace(/<\/script>/g, "");

  x = x.replace(/<(.)?br(.)?>/g, "");
  x = x.replace(/<\/?b>/g, "");
  x = x.replace(/<(ul|ol)><\/(ul|ol)>/gi, "");
  x = x.replace(/<li><\/li>/gi, "");

  x = x.replace(/<!--(.*?)-->/gm, ""); // $ Alert TODO-MISSING: Alert[js/unsafe-html-expansion] Alert[js/incomplete-sanitization] Alert[js/incomplete-html-attribute-sanitization]
  x = x.replace(/\sng-[a-z-]+/, ""); // $ Alert TODO-MISSING: Alert[js/unsafe-html-expansion] Alert[js/incomplete-sanitization] Alert[js/incomplete-html-attribute-sanitization]
  x = x.replace(/\sng-[a-z-]+/g, ""); // $ Alert TODO-MISSING: Alert[js/unsafe-html-expansion] Alert[js/incomplete-sanitization] Alert[js/incomplete-html-attribute-sanitization] - ng-attributes

  x = x.replace(/(<!--\[CDATA\[|\]\]-->)/g, "\n"); // OK - not a sanitizer

  x = x.replace(/<script.+desktop\-only.+<\/script>/g, ""); // $ SPURIOUS: Alert
  x = x.replace(/<script async.+?<\/script>/g, "");
  x = x.replace(/<!--[\s\S]*?-->|<\?(?:php)?[\s\S]*?\?>/gi, ""); // $ Alert TODO-MISSING: Alert[js/unsafe-html-expansion] Alert[js/incomplete-sanitization] Alert[js/incomplete-html-attribute-sanitization]

  x = x.replace(/\x2E\x2E\x2F\x2E\x2E\x2F/g, ""); // $ Alert TODO-MISSING: Alert[js/unsafe-html-expansion] Alert[js/incomplete-sanitization] Alert[js/incomplete-html-attribute-sanitization] - matches "../../"

  x = x.replace(/<script.*>.*<\/script>/gi, ""); // $ Alert TODO-MISSING: Alert[js/unsafe-html-expansion] Alert[js/incomplete-sanitization] Alert[js/incomplete-html-attribute-sanitization]

  x = x.replace(/^(\.\.\/?)+/g, "");

  x = x.replace(/<script\b[^<]*(?:(?!<\/script>)<[^<]*)*<\/script>/g, function( // $ Alert TODO-MISSING: Alert[js/unsafe-html-expansion] Alert[js/incomplete-sanitization] Alert[js/incomplete-html-attribute-sanitization] Alert[js/incomplete-multi-character-sanitization]
    $0
  ) {
    return unknown ? $0 : "";
  }); // $ TODO-SPURIOUS: Alert[js/incomplete-multi-character-sanitization]

  x = x.replace(/<\/?([a-z][a-z0-9]*)\b[^>]*>/gi, ""); // $ MISSING: Alert

  x = x.replace(/\.\./g, "");
  x = x.replace(/\.\.\ // $ Alert TODO-MISSING: Alert[js/unsafe-html-expansion] Alert[js/incomplete-sanitization] Alert[js/incomplete-html-attribute-sanitization]
  x = x.replace(/\/\.\./g, ""); // $ Alert TODO-MISSING: Alert[js/unsafe-html-expansion] Alert[js/incomplete-sanitization] Alert[js/incomplete-html-attribute-sanitization]

  x = x.replace(/<script(.*?)>([\s\S]*?)<\/script>/gi, ""); // $ Alert TODO-MISSING: Alert[js/unsafe-html-expansion] Alert[js/incomplete-sanitization] Alert[js/incomplete-html-attribute-sanitization]

  x = x.replace(/<(script|del)(?=[\s>])[\w\W]*?<\/\1\s*>/gi, ""); // $ Alert TODO-MISSING: Alert[js/unsafe-html-expansion] Alert[js/incomplete-sanitization] Alert[js/incomplete-html-attribute-sanitization]
  x = x.replace(/\<script[\s\S]*?\>[\s\S]*?\<\/script\>/g, ""); // $ Alert TODO-MISSING: Alert[js/unsafe-html-expansion] Alert[js/incomplete-sanitization] Alert[js/incomplete-html-attribute-sanitization]
  x = x.replace(/<(script|style|title)[^<]+<\/(script|style|title)>/gm, ""); // $ Alert TODO-MISSING: Alert[js/unsafe-html-expansion] Alert[js/incomplete-sanitization] Alert[js/incomplete-html-attribute-sanitization]
  x = x.replace(/<script[^>]*>([\s\S]*?)<\/script>/gi, ""); // $ Alert TODO-MISSING: Alert[js/unsafe-html-expansion] Alert[js/incomplete-sanitization] Alert[js/incomplete-html-attribute-sanitization]
  x = x.replace(/<script[\s\S]*?<\/script>/gi, ""); // $ Alert TODO-MISSING: Alert[js/unsafe-html-expansion] Alert[js/incomplete-sanitization] Alert[js/incomplete-html-attribute-sanitization]
  x = x.replace(/ ?<!-- ?/g, ""); // $ Alert TODO-MISSING: Alert[js/unsafe-html-expansion] Alert[js/incomplete-sanitization] Alert[js/incomplete-html-attribute-sanitization]
  x = x.replace(/require\('\.\.\/common'\);/g, "");
  x = x.replace(/\.\.\/\.\.\/lib\//g, "");

  while (x.indexOf(".") !== -1) {
    x = x
      .replace(/^\.\//, "")
      .replace(/\/\.\//, "/")
      .replace(/[^\/]*\/\.\.\//, "");
  }

  x = x.replace(/([^.\s]+\.)+/, "");

  x = x.replace(/<!\-\-DEVEL[\d\D]*?DEVEL\-\->/g, "");

  x = x
    .replace(/^\.\//, "")
    .replace(/\/\.\//, "/")
    .replace(/[^\/]*\/\.\.\ // $ Alert TODO-MISSING: Alert[js/unsafe-html-expansion] Alert[js/incomplete-sanitization] Alert[js/incomplete-html-attribute-sanitization]

  return x;
});

(function (content) {
	content.replace(/<script.*\/script>/gi, ""); // $ Alert TODO-MISSING: Alert[js/unsafe-html-expansion] Alert[js/incomplete-sanitization] Alert[js/incomplete-html-attribute-sanitization]
	content.replace(/<(script).*\/script>/gi, ""); // $ Alert TODO-MISSING: Alert[js/unsafe-html-expansion] Alert[js/incomplete-sanitization] Alert[js/incomplete-html-attribute-sanitization]
	content.replace(/.+<(script).*\/script>/gi, ""); // $ Alert TODO-MISSING: Alert[js/unsafe-html-expansion] Alert[js/incomplete-sanitization] Alert[js/incomplete-html-attribute-sanitization]
	content.replace(/.*<(script).*\/script>/gi, ""); // $ Alert TODO-MISSING: Alert[js/unsafe-html-expansion] Alert[js/incomplete-sanitization] Alert[js/incomplete-html-attribute-sanitization]
});

(function (content) {
  content = content.replace(/<script[\s\S]*?<\/script>/gi, ""); // $ Alert TODO-MISSING: Alert[js/unsafe-html-expansion] Alert[js/incomplete-sanitization] Alert[js/incomplete-html-attribute-sanitization]
  content = content.replace(/<[a-zA-Z\/](.|\n)*?>/g, '') || ' '; // $ Alert TODO-MISSING: Alert[js/unsafe-html-expansion] Alert[js/incomplete-sanitization] Alert[js/incomplete-html-attribute-sanitization]
  content = content.replace(/<(script|iframe|video)[\s\S]*?<\/(script|iframe|video)>/g, '') // $ Alert TODO-MISSING: Alert[js/unsafe-html-expansion] Alert[js/incomplete-sanitization] Alert[js/incomplete-html-attribute-sanitization]
  content = content.replace(/<(script|iframe|video)(.|\s)*?\/(script|iframe|video)>/g, '') // $ Alert TODO-MISSING: Alert[js/unsafe-html-expansion] Alert[js/incomplete-sanitization] Alert[js/incomplete-html-attribute-sanitization]
  content = content.replace(/<[^<]*>/g, "");

  n.cloneNode(false).outerHTML.replace(/<\/?[\w:\-]+ ?|=[\"][^\"]+\"|=\'[^\']+\'|=[\w\-]+|>/gi, '').replace(/[\w:\-]+/gi, function(a) { // $ Alert TODO-MISSING: Alert[js/unsafe-html-expansion] Alert[js/incomplete-sanitization] Alert[js/incomplete-html-attribute-sanitization]
    o.push({specified : 1, nodeName : a});
  });

  n.cloneNode(false).outerHTML.replace(/<\/?[\w:\-]+ ?|=[\"][^\"]+\"|=\'[^\']+\'|=[\w\-]+|>/gi, '').replace(/[\w:\-]+/gi, function(a) { // $ Alert TODO-MISSING: Alert[js/unsafe-html-expansion] Alert[js/incomplete-sanitization] Alert[js/incomplete-html-attribute-sanitization]
    o.push({specified : 1, nodeName : a});
  });  

  content = content.replace(/.+?(?=\s)/, '');
});