function optionalPrefix(x) {
  return /^(https:)?/.test(x); // $ Alert
}

function mandatoryPrefix(x) {
  return /^https:/.test(x);
}

function httpOrHttps(x) {
  return /^https?:/.test(x);
}

function optionalSuffix(x) {
  return /(\.com)?$/.test(x); // $ Alert
}

function mandatorySuffix(x) {
  return /\.com$/.test(x);
}

function protocol(x) {
  return /^(?:https?:|ftp:|file:)?/.test(x); // $ Alert
}

function doubleAnchored(x) {
  return /^(foo|bar)?$/.test(x);
}

function noAnchor(x) {
  return /(foo|bar)?/.test(x); // $ Alert
}

function altAnchor(x) {
  return /^foo|bar$|(baz)?/.test(x); // $ Alert
}

function wildcard(x) {
  return /.*/.test(x); // OK - obviously intended to match anything
}

function wildcard2(x) {
  return /[\d\D]*/.test(x); // OK - obviously intended to match anything
}

function emptyAlt(x) {
  return /^$|foo|bar/.test(x);
}

function emptyAlt2(x) {
  return /(^$|foo|bar)/.test(x);
}

function emptyAlt3(x) {
  return /((^$|foo|bar))/.test(x);
}

function search(x) {
  return x.search(/[a-z]*/) > -1; // $ Alert
}

function search2(x) {
  return x.search(/[a-z]/) > -1;
}

function lookahead(x) {
  return x.search(/(?!x)/) > -1;
}

function searchPrefix(x) {
  return x.search(/^(foo)?/) > -1; // $ Alert - `foo?` does not affect the returned index
}

function searchSuffix(x) {
  return x.search(/(foo)?$/) > -1; // OK - `foo?` affects the returned index
}

function wordBoundary(x) {
  return /\b/.test(x); // OK - some strings don't have word boundaries
}

function nonWordBoundary(x) {
  return /\B/.test(x); // OK - some strings don't have non-word boundaries
}

function emptyRegex(x) {
  return new RegExp("").test(x);
}

function parserTest(x) {
  /(\w\s*:\s*[^:}]+|#){|@import[^\n]+(?:url|,)/.test(x);
  /^((?:a{0,2}|-)|\w\{\d,\d\})+X$/.text(x);
}
