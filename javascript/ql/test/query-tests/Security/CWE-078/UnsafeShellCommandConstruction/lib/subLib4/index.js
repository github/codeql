const dispatch = {
  GET: require("./bla"),
  POST: require("./subsub"),
};

module.exports.foo = function (name, type) { // $ Source
  dispatch[type](name);
};
