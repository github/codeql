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