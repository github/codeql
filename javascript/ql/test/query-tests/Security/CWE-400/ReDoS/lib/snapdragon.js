var Snapdragon = require("snapdragon");

module.exports.test1 = function (input) { // $ Source[js/polynomial-redos]
  var snapdragon = new Snapdragon();
  var ast = snapdragon.parser
    .set("foo", function () {
      var m = this.match(/aa*$/); // $ Alert[js/polynomial-redos]
    })
    .parse(input, options);
};

module.exports.test2 = function (input) { // $ Source[js/polynomial-redos]
  var snapdragon = new Snapdragon();
  snapdragon.parser.set("foo", function () {
    var m = this.match(/aa*$/); // $ Alert[js/polynomial-redos]
  });
  snapdragon.parse(input, options);
};

module.exports.test3 = function (input) { // $ Source[js/polynomial-redos]
  var snapdragon = new Snapdragon();
  snapdragon.compiler.set("foo", function (node) {
    node.val.match(/aa*$/); // $ Alert[js/polynomial-redos]
  });
  snapdragon.compile(input, options);
};
