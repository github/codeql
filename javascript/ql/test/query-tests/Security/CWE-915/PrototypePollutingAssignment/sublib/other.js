(function () {
  function Foobar() {}

  Foobar.prototype = {
    method: function (obj, path, value) {
      obj[path[0]][path[1]] = value; // NOT OK
    },
  };

  module.exports.foobar = Foobar;

  module.other.notExported = function (obj, path, value) {
    obj[path[0]][path[1]] = value; // OK - not exported
  }
})();
