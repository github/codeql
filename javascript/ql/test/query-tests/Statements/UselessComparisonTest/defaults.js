function defaultParam(param = 0) {
  if (param > 0) {}
}

function defaultPattern(obj, arr) {
  let { prop = 0 } = obj;
  if (prop > 0) {}

  let [ elm = 0 ] = arr;
  if (elm > 0) {}
}
