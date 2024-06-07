function optionalPrefix(x) {
  return /^(https:)?/.test(x); // NOT OK
}

function mandatoryPrefix(x) {
  return /^https:/.test(x); // OK
}

function httpOrHttps(x) {
  return /^https?:/.test(x); // OK
}

function optionalSuffix(x) {
  return /(\.com)?$/.test(x); // NOT OK
}

function mandatorySuffix(x) {
  return /\.com$/.test(x); // OK
}

function protocol(x) {
  return /^(?:https?:|ftp:|file:)?/.test(x); // NOT OK
}

function doubleAnchored(x) {
  return /^(foo|bar)?$/.test(x); // OK
}

function noAnchor(x) {
  return /(foo|bar)?/.test(x); // NOT OK
}

function altAnchor(x) {
  return /^foo|bar$|(baz)?/.test(x); // NOT OK
}

function wildcard(x) {
  return /.*/.test(x); // OK - obviously intended to match anything
}

function wildcard2(x) {
  return /[\d\D]*/.test(x); // OK - obviously intended to match anything
}

function emptyAlt(x) {
  return /^$|foo|bar/.test(x); // OK
}

function emptyAlt2(x) {
  return /(^$|foo|bar)/.test(x); // OK
}

function emptyAlt3(x) {
  return /((^$|foo|bar))/.test(x); // OK
}

function search(x) {
  return x.search(/[a-z]*/) > -1; // NOT OK
}

function search2(x) {
  return x.search(/[a-z]/) > -1; // OK
}

function lookahead(x) {
  return x.search(/(?!x)/) > -1; // OK
}

function searchPrefix(x) {
  return x.search(/^(foo)?/) > -1; // NOT OK - `foo?` does not affect the returned index
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
  return new RegExp("").test(x); // OK
}

function parserTest(x) {
  /(\w\s*:\s*[^:}]+|#){|@import[^\n]+(?:url|,)/.test(x); // OK
  /^((?:a{0,2}|-)|\w\{\d,\d\})+X$/.text(x); // ok
}
