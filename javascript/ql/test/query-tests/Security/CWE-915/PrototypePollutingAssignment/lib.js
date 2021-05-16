module.exports.set = function recSet(obj, path, value) {
  var currentPath = path[0];
  var currentValue = obj[currentPath];
  if (path.length === 1) {
    if (currentValue === void 0) {
      obj[currentPath] = value; // NOT OK
    }
    return currentValue;
  }

  return recSet(obj[currentPath], path.slice(1), value);
}

module.exports.set2 = function (obj, path, value) {
  obj[path[0]][path[1]] = value; // NOT OK
}

module.exports.setWithArgs = function() {
  var obj = arguments[0];
  var path = arguments[1];
  var value = arguments[2];
  obj[path[0]][path[1]] = value; // NOT OK
}