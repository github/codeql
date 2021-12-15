function defaultParam(param = 0) {
  if (param > 0) {} // OK
}

function defaultPattern(obj, arr) {
  let { prop = 0 } = obj;
  if (prop > 0) {} // OK

  let [ elm = 0 ] = arr;
  if (elm > 0) {} // OK
}
