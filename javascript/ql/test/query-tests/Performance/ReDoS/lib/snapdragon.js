var Snapdragon = require("snapdragon");

module.exports.test1 = function (input) {
  var snapdragon = new Snapdragon();
  var ast = snapdragon.parser
    .set("foo", function () {
      var m = this.match(/aa*$/); // NOT OK
    })
    .parse(input, options);
};

module.exports.test2 = function (input) {
  var snapdragon = new Snapdragon();
  snapdragon.parser.set("foo", function () {
    var m = this.match(/aa*$/); // NOT OK
  });
  snapdragon.parse(input, options);
};

module.exports.test3 = function (input) {
  var snapdragon = new Snapdragon();
  snapdragon.compiler.set("foo", function (node) {
    node.val.match(/aa*$/); // NOT OK
  });
  snapdragon.compile(input, options);
};
