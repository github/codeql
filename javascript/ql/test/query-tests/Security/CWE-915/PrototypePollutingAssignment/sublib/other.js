(function () {
  function Foobar() {}

  Foobar.prototype = {
    method: function (obj, path, value) {
      obj[path[0]][path[1]] = value; // NOT OK - but not flagged [INCONSISTENCY]
    },
  };

  module.exports.foobar = Foobar;
})();
