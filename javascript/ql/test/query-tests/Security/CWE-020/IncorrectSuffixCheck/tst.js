function endsWith(x, y) {
  return x.indexOf(y) === x.length - y.length; // $ Alert
}
function endsWithGood(x, y) {
  return x.length >= y.length && x.indexOf(y) === x.length - y.length;
}

function withStringConcat(x, y) {
  return x.indexOf("/" + y) === x.length - y.length - 1; // $ Alert
}
function withStringConcatGood(x, y) {
  return x.length > y.length && x.indexOf("/" + y) === x.length - y.length - 1;
}

function withDelta(x, y) {
  let delta = x.length - y.length;
  return x.indexOf(y) === delta; // $ Alert
}
function withDeltaGood(x, y) {
  let delta = x.length - y.length;
  return delta >= 0 && x.indexOf(y) === delta;
}

function literal(x) {
  return x.indexOf("example.com") === x.length - "example.com".length; // $ Alert
}
function literalGood(x) {
  return x.length >= "example.com".length && x.indexOf("example.com") === x.length - "example.com".length;
}

function intLiteral(x) {
  return x.indexOf("example.com") === x.length - 11; // $ Alert
}
function intLiteralGood(x) {
  return x.length >= 11 && x.indexOf("example.com") === x.length - 11;
}

function lastIndexOf(x, y) {
  return x.lastIndexOf(y) === x.length - y.length; // $ Alert
}
function lastIndexOfGood(x, y) {
  return x.length >= y.length && x.lastIndexOf(y) === x.length - y.length;
}

function withIndexOfCheckGood(x, y) {
  let index = x.indexOf(y);
  return index !== -1 && index === x.length - y.length - 1;
}

function indexOfCheckEquality(x, y) {
  return x.indexOf(y) !== -1 && x.indexOf(y) === x.length - y.length - 1;
}

function indexOfCheckEqualityBad(x, y) {
  return x.indexOf(y) !== 0 && x.indexOf(y) === x.length - y.length - 1; // $ Alert
}

function indexOfCheckGood(x, y) {
  return x.indexOf(y) >= 0 && x.indexOf(y) === x.length - y.length - 1;
}

function indexOfCheckGoodSharp(x, y) {
  return x.indexOf(y) > -1 && x.indexOf(y) === x.length - y.length - 1;
}

function indexOfCheckBad(x, y) {
  return x.indexOf(y) >= -1 && x.indexOf(y) === x.length - y.length - 1; // $ Alert
}

function endsWithSlash(x) {
  return x.indexOf("/") === x.length - 1; // OK - even though it also matches the empty string
}

function withIndexOfCheckBad(x, y) {
  let index = x.indexOf(y);
  return index !== 0 && index === x.length - y.length - 1; // $ Alert
}

function plus(x, y) {
  return x.indexOf("." + y) === x.length - (y.length + 1); // $ Alert
}

function withIndexOfCheckLower(x, y) {
  let index = x.indexOf(y);
  return !(index < 0) && index === x.length - y.length - 1;
}

function withIndexOfCheckLowerEq(x, y) {
  let index = x.indexOf(y);
  return !(index <= -1) && index === x.length - y.length - 1;
}

function lastIndexNeqMinusOne(x) {
  return x.lastIndexOf("example.com") !== -1 && x.lastIndexOf("example.com") === x.length - "example.com".length;
}

function lastIndexEqMinusOne(x) {
  return x.lastIndexOf("example.com") === -1 || x.lastIndexOf("example.com") === x.length - "example.com".length;
}

function sameCheck(allowedOrigin) {
    const trustedAuthority = "example.com";

    const ind = trustedAuthority.indexOf("." + allowedOrigin);
    return ind > 0 && ind === trustedAuthority.length - allowedOrigin.length - 1;
}

function sameConcatenation(allowedOrigin) {
    const trustedAuthority = "example.com";
    return trustedAuthority.indexOf("." + allowedOrigin) > 0 && trustedAuthority.indexOf("." + allowedOrigin) === trustedAuthority.length - allowedOrigin.length - 1;
}