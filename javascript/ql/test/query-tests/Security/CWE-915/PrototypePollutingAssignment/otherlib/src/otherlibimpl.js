module.exports.set = function (obj, path, value) {
  obj[path[0]][path[1]] = value; // NOT OK
}