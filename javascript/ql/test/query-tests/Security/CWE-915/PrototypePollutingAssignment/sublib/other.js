(function () {
  function Foobar() {}

  Foobar.prototype = {
    method: function (obj, path, value) { // $ Source
      obj[path[0]][path[1]] = value; // $ Alert
    },
  };

  module.exports.foobar = Foobar;

  module.other.notExported = function (obj, path, value) {
    obj[path[0]][path[1]] = value; // OK - not exported
  }
})();
