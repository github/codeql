function endsWith(x, y) {
  return x.indexOf(y) === x.length - y.length; // NOT OK
}
function endsWithGood(x, y) {
  return x.length >= y.length && x.indexOf(y) === x.length - y.length; // OK
}

function withStringConcat(x, y) {
  return x.indexOf("/" + y) === x.length - y.length - 1; // NOT OK
}
function withStringConcatGood(x, y) {
  return x.length > y.length && x.indexOf("/" + y) === x.length - y.length - 1; // OK
}

function withDelta(x, y) {
  let delta = x.length - y.length;
  return x.indexOf(y) === delta; // NOT OK
}
function withDeltaGood(x, y) {
  let delta = x.length - y.length;
  return delta >= 0 && x.indexOf(y) === delta; // OK
}

function literal(x) {
  return x.indexOf("example.com") === x.length - "example.com".length; // NOT OK
}
function literalGood(x) {
  return x.length >= "example.com".length && x.indexOf("example.com") === x.length - "example.com".length;
}

function intLiteral(x) {
  return x.indexOf("example.com") === x.length - 11; // NOT OK
}
function intLiteralGood(x) {
  return x.length >= 11 && x.indexOf("example.com") === x.length - 11;
}

function lastIndexOf(x, y) {
  return x.lastIndexOf(y) === x.length - y.length; // NOT OK
}
function lastIndexOfGood(x, y) {
  return x.length >= y.length && x.lastIndexOf(y) === x.length - y.length; // OK
}

function withIndexOfCheckGood(x, y) {
  let index = x.indexOf(y);
  return index !== -1 && index === x.length - y.length - 1; // OK
}

function indexOfCheckEquality(x, y) {
  return x.indexOf(y) !== -1 && x.indexOf(y) === x.length - y.length - 1; // OK
}

function indexOfCheckEqualityBad(x, y) {
  return x.indexOf(y) !== 0 && x.indexOf(y) === x.length - y.length - 1; // NOT OK
}

function indexOfCheckGood(x, y) {
  return x.indexOf(y) >= 0 && x.indexOf(y) === x.length - y.length - 1; // OK
}

function indexOfCheckGoodSharp(x, y) {
  return x.indexOf(y) > -1 && x.indexOf(y) === x.length - y.length - 1; // OK
}

function indexOfCheckBad(x, y) {
  return x.indexOf(y) >= -1 && x.indexOf(y) === x.length - y.length - 1; // NOT OK
}

function endsWithSlash(x) {
  return x.indexOf("/") === x.length - 1; // OK - even though it also matches the empty string
}

function withIndexOfCheckBad(x, y) {
  let index = x.indexOf(y);
  return index !== 0 && index === x.length - y.length - 1; // NOT OK
}

function plus(x, y) {
  return x.indexOf("." + y) === x.length - (y.length + 1); // NOT OK
}

function withIndexOfCheckLower(x, y) {
  let index = x.indexOf(y);
  return !(index < 0) && index === x.length - y.length - 1; // OK
}

function withIndexOfCheckLowerEq(x, y) {
  let index = x.indexOf(y);
  return !(index <= -1) && index === x.length - y.length - 1; // OK
}

function lastIndexNeqMinusOne(x) {
  return x.lastIndexOf("example.com") !== -1 && x.lastIndexOf("example.com") === x.length - "example.com".length; // OK
}

function lastIndexEqMinusOne(x) {
  return x.lastIndexOf("example.com") === -1 || x.lastIndexOf("example.com") === x.length - "example.com".length; // OK
}
